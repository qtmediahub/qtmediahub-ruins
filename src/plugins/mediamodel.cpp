/****************************************************************************
 *
 * This file is part of the QtMediaHub project on http://www.gitorious.org.
 *
 * Copyright (c) 2009 Nokia Corporation and/or its subsidiary(-ies).*
 * All rights reserved.
 *
 * Contact:  Nokia Corporation (qt-info@nokia.com)**
 *
 * You may use this file under the terms of the BSD license as follows:
 *
 * "Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
 *
 * ****************************************************************************/

#include "mediamodel.h"
#include <QDirIterator>
#include <QThreadPool>
#include <QTimer>
#include <QtDebug>
#include <QMetaEnum>
#include <QDeclarativeEngine>

#include <taglib/tag.h>
#include <taglib/fileref.h>
#include <taglib/mpeg/mpegfile.h>
#include <taglib/mpeg/id3v2/id3v2tag.h>
#include <taglib/mpeg/id3v2/frames/attachedpictureframe.h>

MediaModel::MediaModel(MediaModel::MediaType type, QObject *parent)
    : QAbstractItemModel(parent),
      m_type(type),
      m_thread(0),
      m_nowSearching(-1)
{
    qRegisterMetaType<MediaInfo>("MediaInfo");

    QHash<int, QByteArray> roleNames;
    roleNames[Qt::DisplayRole] = "display";
    roleNames[DecorationUrlRole] = "decorationUrl";
    roleNames[TitleRole] = "title";
    roleNames[AlbumRole] = "album";
    roleNames[CommentRole] = "comment";
    roleNames[GenreRole] = "genre";
    roleNames[FilePathRole] = "filePath";
    roleNames[FileNameRole] = "fileName";
    setRoleNames(roleNames);

    Data *data = new Data(QString("/AddNewSource"), tr("Add new source"));
    m_data.append(data);
}

MediaModel::~MediaModel()
{
    for (int i = 0; i < m_data.count(); i++)
        qDeleteAll(m_data[i]->musicInfos);
    qDeleteAll(m_data);

    // FIXME: Wait until thread is dead
    delete m_thread;
}

void MediaModel::startSearchThread()
{
    if (m_nowSearching != -1)
        return; // already searching some directory

    int i;
    for (i = 0; i < m_data.count()-1; i++) { // leave out the last item
        if (m_data[i]->status == Data::NotSearched)
            break;
    }
    if (i == m_data.count()-1) {
        m_nowSearching = -1;
        return; // all searched
    }

    Q_ASSERT(!m_thread);
    m_thread = new MediaModelThread(this, i, m_data[i]->searchPath);
    m_thread->setAutoDelete(false);
    m_data[i]->status = Data::Searching;
    m_nowSearching = i;
    connect(m_thread, SIGNAL(musicFound(int, MediaInfo, QImage)), this, SLOT(addMedia(int, MediaInfo, QImage)));
    connect(m_thread, SIGNAL(finished()), this, SLOT(searchThreadFinished()));
    QThreadPool::globalInstance()->start(m_thread);
}

void MediaModel::searchThreadFinished()
{
    Q_ASSERT(m_nowSearching != -1);
    Q_ASSERT(m_thread);
    m_data[m_nowSearching]->status = Data::Searched;
    m_nowSearching = -1;
    delete m_thread;
    m_thread = 0;

    startSearchThread();
}

void MediaModel::stopSearchThread()
{
    m_thread->stop();
}

void MediaModel::addSearchPath(const QString &path, const QString &name)
{
    beginInsertRows(QModelIndex(), m_data.count()-1, m_data.count()-1);
    Data *data = new Data(path, name);
    MediaInfo *mi = new MediaInfo;
    mi->fileName = tr("..");
    mi->filePath = "/DotDot";
    data->musicInfos.append(mi);
    m_data.insert(m_data.count()-1, data);
    endInsertRows();
    m_frontCovers.insert(path, QImage(m_themePath + "/media/DefaultHardDisk.png"));

    startSearchThread();
}

QModelIndex MediaModel::index(int row, int col, const QModelIndex &parent) const
{
    if (col != 0 || row < 0)
        return QModelIndex();
    if (!parent.isValid()) { // top level
        if (row >= m_data.count())
            return QModelIndex();
        return createIndex(row, 0, 0);
    } else { // first level
        Data *data = m_data.value(parent.row());
        if (!data || row >= data->musicInfos.count())
            return QModelIndex();
        return createIndex(row, col, data);
    }
}

QModelIndex MediaModel::parent(const QModelIndex &idx) const
{
    if (!idx.isValid())
        return QModelIndex();
    if (idx.internalPointer() == 0) // top level
        return QModelIndex();
    Data *data = static_cast<Data *>(idx.internalPointer());
    int loc = m_data.indexOf(data);
    if (loc == -1)
        return QModelIndex();
    return createIndex(loc, 0, 0);
}

int MediaModel::columnCount(const QModelIndex &idx) const
{
    Q_UNUSED(idx);
    return 1;
}

int MediaModel::rowCount(const QModelIndex &parent) const
{
    if (!parent.isValid())
        return m_data.count();
    if (parent.internalPointer() == 0) { // top level
        Data *data = m_data.value(parent.row());
        return data ? data->musicInfos.count() : 0;
    } else {
        return 0;
    }
}

QVariant MediaModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (index.internalPointer() == 0) { // top level
        Data *data = m_data.value(index.row());
        if (!data)
            return QVariant();
        if (role == Qt::DisplayRole) {
            return data->name;
        } else if (role == Qt::DecorationRole) {
        } else if (role == DecorationUrlRole) {
            return QUrl("image://" + imageBaseUrl() + data->searchPath);
        } else if (role == FilePathRole) {
            return data->searchPath;
        }

        return QVariant();
    }

    Data *data = static_cast<Data *>(index.internalPointer());
    MediaInfo *info = data->musicInfos[index.row()];
    if (role == Qt::DisplayRole) {
        if (info->title.isEmpty())
            return info->fileName;
        QString title = info->title;
        if (!info->album.isEmpty())
            title.append(QLatin1String(" (") + info->album + QLatin1String(")"));
        return title;
    } else if (role == Qt::DecorationRole) {
        return QVariant(); // FIX
//        return decorationPixmap(info);
    } else if (role == TitleRole) {
        return info->title;
    } else if (role == AlbumRole) {
        return info->album;
    } else if (role == CommentRole) {
        return info->comment;
    } else if (role == GenreRole) {
        return info->genre;
    } else if (role == FilePathRole) {
        return info->filePath;
    } else if (role == FileNameRole) {
        return info->fileName;
    } else if (role == DecorationUrlRole) {
        return QUrl("image://" + imageBaseUrl() + info->filePath);
    } else {
        return QVariant();
    }
}

void MediaModel::addMedia(int row, const MediaInfo &music, const QImage &frontCover)
{
    Data *data = m_data[row];
    beginInsertRows(createIndex(row, 0, 0), data->musicInfos.count(), data->musicInfos.count());
    MediaInfo *mi = new MediaInfo(music);
    if (!frontCover.isNull()) {
        m_frontCovers.insert(mi->filePath, frontCover);
    } else {
        m_frontCovers.insert(mi->filePath, QImage(m_themePath + "/media/Fanart_Fallback_Music_Small.jpg")); // FIXME: Make this configurable
    }
    data->musicInfos.append(mi);
    endInsertRows();
}

QPixmap MediaModel::decorationPixmap(const QString &_path, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(requestedSize);
    QString path = '/' + _path;
    if (!m_frontCovers.contains(path)) {
        return QPixmap();
    }
    QPixmap pixmap;
    if (!QPixmapCache::find("coverart_" + path, &pixmap)) {
        pixmap = QPixmap::fromImage(m_frontCovers[path]);
        QPixmapCache::insert("coverart_" + path, pixmap);
    }
    *size = pixmap.size();
    return pixmap;
}

QImage MediaModel::decorationImage(const QString &path, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(requestedSize);
    if (!m_frontCovers.contains(path))
        return QImage();
    QImage img = m_frontCovers.value(path);
    *size = img.size();
    return img;
}

void MediaModel::setThemeResourcePath(const QString &themePath)
{
    m_themePath = themePath;
    m_frontCovers.insert("/AddNewSource", QImage(m_themePath + "/media/DefaultAddSource.png"));
    m_frontCovers.insert("/DotDot", QImage(m_themePath + "/media/DefaultFolderBack.png"));
    reset();
}

static inline QString fromTagString(const TagLib::String &string)
{
    return QString::fromStdWString(string.toWString());
}

static void popuplateGenericTagInfo(MediaInfo *info, TagLib::Tag *tag)
{
    info->title = fromTagString(tag->title());
    info->artist = fromTagString(tag->artist());
    info->album = fromTagString(tag->album());
    info->comment = fromTagString(tag->comment());
    info->genre = fromTagString(tag->genre());
    info->year = tag->year();
    info->track = tag->track();
}

static void popuplateAudioProperties(MediaInfo *info, TagLib::AudioProperties *properties)
{
    info->length = properties->length();
    info->bitrate = properties->bitrate();
    info->sampleRate = properties->sampleRate();
    info->channels = properties->channels();
}

static QImage readFrontCover(TagLib::ID3v2::Tag *id3v2Tag)
{
    TagLib::ID3v2::FrameList frames = id3v2Tag->frameListMap()["APIC"];
    if (frames.isEmpty()) {
        //qDebug() << "No front cover";
        return QImage();
    }

    TagLib::ID3v2::AttachedPictureFrame *selectedFrame = 0;
    if (frames.size() != 1) {
        TagLib::ID3v2::FrameList::Iterator it = frames.begin();
        for (; it != frames.end(); ++it) {
            TagLib::ID3v2::AttachedPictureFrame *frame = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
            if (frame && frame->type() != TagLib::ID3v2::AttachedPictureFrame::FrontCover) // BackCover, LeafletPage
                continue;
            selectedFrame = frame;
            break;
        }
    }
    if (!selectedFrame)
        selectedFrame = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(frames.front());
    if (!selectedFrame)
        return QImage();

    QByteArray imageData(selectedFrame->picture().data(), selectedFrame->picture().size());
    QImage attachedImage = QImage::fromData(imageData);
    // ## scale as necessary
    return attachedImage;
}

MediaModelThread::MediaModelThread(MediaModel *model, int row, const QString &searchPath)
    : m_model(model), m_stop(false), m_row(row), m_searchPath(searchPath)
{
}

MediaModelThread::~MediaModelThread()
{
}

void MediaModelThread::stop()
{
    m_stop = true;
}

void MediaModelThread::run()
{
    emit started();

    Q_ASSERT(!m_searchPath.isEmpty() && m_searchPath != tr("/AddNewSource"));

    search();

    emit finished();
}

void MediaModelThread::search()
{
    QDirIterator it(m_searchPath, QDir::Files | QDir::NoDotAndDotDot, QDirIterator::Subdirectories);
    while (!m_stop && it.hasNext()) {
        MediaInfo info;
        info.filePath = it.next();
        info.fileName = it.fileName();
        QByteArray fileName = QFile::encodeName(info.filePath);
        
        TagLib::FileRef fileRef(fileName.constData());
        if (fileRef.isNull()) {
            // qDebug() << "Dropping " << info.path;
            continue;
        }

        TagLib::File *file = fileRef.file();
        if (TagLib::Tag *tag = file->tag())
            popuplateGenericTagInfo(&info, tag);
        if (TagLib::AudioProperties *audioProperties = file->audioProperties())
            popuplateAudioProperties(&info, audioProperties);

        // Populate music type specific fields
        QImage frontCover;
        if (TagLib::MPEG::File *mpegFile = dynamic_cast<TagLib::MPEG::File *>(file)) {
            TagLib::ID3v2::Tag *id3v2Tag = mpegFile->ID3v2Tag(false);
            if (id3v2Tag)
                frontCover = readFrontCover(id3v2Tag);
        }

        emit musicFound(m_row, info, frontCover);
   }
}

void MediaModel::registerImageProvider(QDeclarativeContext *context)
{
    context->engine()->addImageProvider(imageBaseUrl(), new MediaImageProvider(this));
}

QString MediaModel::typeString() const
{
    int idx = MediaModel::staticMetaObject.indexOfEnumerator("MediaType");
    QMetaEnum e = MediaModel::staticMetaObject.enumerator(idx);
    return QString::fromLatin1(e.valueToKey(m_type));
}

void MediaModel::dump()
{
    qDebug() << m_data.count() << "elements";
    for (int i = 0; i < m_data.count(); i++) {
        qDebug() << m_data[i]->searchPath;
        for(int j = 0; j < m_data[i]->musicInfos.count(); j++)
            qDebug() << "\t\t" << m_data[i]->musicInfos[j]->filePath;
    }
}

