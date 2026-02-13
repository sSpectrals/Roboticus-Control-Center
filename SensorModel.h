#ifndef SENSORMODEL_H
#define SENSORMODEL_H

#include <QAbstractListModel>
#include <QQmlEngine>
#include <QUuid>

struct Sensor {
  QUuid id;
  QString name = "No Name Set";
  double inputValue = -1.0;
  double threshold = -1.0;
  QString selectedOperator = "==";
  double x = 0.0;
  double y = 0.0;

  Sensor() : id(QUuid::createUuid()) {}
};

class SensorModel : public QAbstractListModel {
  Q_OBJECT
  QML_ELEMENT

  Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
  enum Roles {
    IdRole = Qt::UserRole + 1,
    NameRole,
    InputRole,
    ThresholdRole,
    OperatorRole,
    XRole,
    YRole
  };
  Q_ENUM(Roles)

  explicit SensorModel(QObject *parent = nullptr);

  virtual int
  rowCount(const QModelIndex &parent = QModelIndex()) const override;
  virtual QVariant data(const QModelIndex &index, int role) const override;
  virtual bool setData(const QModelIndex &index, const QVariant &value,
                       int role) override;
  virtual QHash<int, QByteArray> roleNames() const override;

  Q_INVOKABLE QUuid addSensor();
  Q_INVOKABLE bool removeSensor(const QUuid &id);

  int getIndexFromId(const QUuid &id) const;

signals:
  void sensorAdded(const QUuid &id);
  void sensorRemoved(const QUuid &id);
  void countChanged();

private:
  QList<Sensor> m_sensors;
};

#endif // SENSORMODEL_H
