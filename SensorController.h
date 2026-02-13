#ifndef SENSORCONTROLLER_H
#define SENSORCONTROLLER_H

#include <QObject>
#include <QQmlEngine>
#include <SensorModel.h>

class SensorController : public QObject {
  Q_OBJECT
  QML_ELEMENT

  Q_PROPERTY(SensorModel *model READ model CONSTANT)
public:
  explicit SensorController(QObject *parent = nullptr);

  SensorModel *model() const { return m_model; }

  Q_INVOKABLE Sensor addSensor(const QString &name = QString(),
                               double threshold = 100.0,
                               const QString &op = ">=", double x = 0.0,
                               double y = 0.0);

  Q_INVOKABLE bool removeSensor(const QUuid &id);

  Q_INVOKABLE bool setSensorValue(const QUuid &id, double value);
  Q_INVOKABLE bool setSensorThreshold(const QUuid &id, double threshold);
  Q_INVOKABLE bool setSensorOperator(const QUuid &id, const QString &op);
  Q_INVOKABLE bool setSensorName(const QUuid &id, const QString &name);
  Q_INVOKABLE bool setSensorPositionXY(const QUuid &id, double x, double y);
  Q_INVOKABLE bool setSensorPositionX(const QUuid &id, double x);
  Q_INVOKABLE bool setSensorPositionY(const QUuid &id, double y);

signals:
  void sensorAdded(const QUuid &id, const QString &name, double threshold,
                   const QString &op, double x, double y);
  void sensorRemoved(const QUuid &id);

private:
  SensorModel *m_model;
};

#endif // SENSORCONTROLLER_H
