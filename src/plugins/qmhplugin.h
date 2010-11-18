#ifndef QMHPLUGIN_H
#define QMHPLUGIN_H

#include <QObject>

#include "qmhplugininterface.h"

class GenericPlugin : public QObject, public QMHPluginInterface
{
    Q_OBJECT
    Q_INTERFACES(QMHPluginInterface)
public:
    GenericPlugin()
        : QObject(),
          QMHPluginInterface(),
          mName("Skin Plugin"),
          mBrowseable(false),
          mRole("undefined") { /* */ }
    ~GenericPlugin() {}
    
    QString name() const { return mName; }
    void setName(const QString &name) { mName = name; }

    bool browseable() const { return mBrowseable; }
    void setBrowseable(bool browseable) { mBrowseable = browseable; }

    QString role() const { return mRole; }
    void setRole(const QString &role) { mRole = role; }
private:
    QString mName;
    bool mBrowseable;
    QString mRole;
};

class QMHPlugin : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY pluginChanged)
    Q_PROPERTY(bool browseable READ browseable WRITE setBrowseable NOTIFY pluginChanged)
    Q_PROPERTY(QString role READ role WRITE setRole NOTIFY pluginChanged)
    Q_PROPERTY(QList<QObject*> childItems READ childItems NOTIFY pluginChanged)
public:
    QMHPlugin(QMHPluginInterface *interface = new GenericPlugin(), QObject *parent = 0)
        : QObject(parent)
        , mInterface(interface)
    {}

    QString name() const { return mInterface->name(); }
    void setName(const QString &name) { mInterface->setName(name); }

    bool browseable() const { return mInterface->browseable(); }
    void setBrowseable(bool browseable) { mInterface->setBrowseable(browseable); }

    QString role() const { return mInterface->role(); }
    void setRole(const QString &role) { mInterface->setRole(role); }

    QList<QObject*> childItems() const { return mInterface->childItems(); }

signals:
    void pluginChanged();

private:
    QMHPluginInterface *mInterface;
}
;

#endif // QMHPLUGIN_H
