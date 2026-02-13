#include "SensorController.h"
#include <QDebug>

SensorController::SensorController(QObject *parent)
    : QObject(parent), m_model(new SensorModel(this)) {

  connect(m_model, &SensorModel::sensorAdded, this,
          &SensorController::sensorAdded);
  connect(m_model, &SensorModel::sensorRemoved, this,
          &SensorController::sensorRemoved);
}

Q_INVOKABLE QUuid SensorController::addSensor(const QString &name,
                                              double threshold,
                                              const QString &op) {

  if (!m_model)
    return QUuid();


    QUuid newSensor = m_model->addSensor();

    emit sensorAdded(newSensor);
    return newSensor;

}

Q_INVOKABLE bool SensorController::removeSensor(const QUuid &id) {

  if (!m_model)
    return false;

  return m_model->removeSensor(id);
}

Q_INVOKABLE bool SensorController::setSensorValue(const QUuid &id,
                                                  double value) {

  if (!m_model)
    return false;

  int index = m_model->getIndexFromId(id);
  if (index < 0)
    return false;

  return m_model->setData(m_model->index(index), value, SensorModel::InputRole);
}

Q_INVOKABLE bool SensorController::setSensorThreshold(const QUuid &id,
                                                      double threshold) {

  if (!m_model)
    return false;

  int index = m_model->getIndexFromId(id);
  if (index < 0)
    return false;

  return m_model->setData(m_model->index(index), threshold,
                          SensorModel::ThresholdRole);
}

Q_INVOKABLE bool SensorController::setSensorOperator(const QUuid &id,
                                                     const QString &op) {

  if (!m_model)
    return false;

  int index = m_model->getIndexFromId(id);
  if (index < 0)
    return false;

  return m_model->setData(m_model->index(index), op, SensorModel::OperatorRole);
}

Q_INVOKABLE bool SensorController::setSensorName(const QUuid &id,
                                                 const QString &name) {

  if (!m_model)
    return false;

  int index = m_model->getIndexFromId(id);
  if (index < 0)
    return false;

  return m_model->setData(m_model->index(index), name, SensorModel::NameRole);
}

Q_INVOKABLE bool SensorController::setSensorPositionXY(const QUuid &id,
                                                       double x, double y) {
  if (!m_model)
    return false;

  return setSensorPositionX(id, x) && setSensorPositionY(id, y);
}

Q_INVOKABLE bool SensorController::setSensorPositionX(const QUuid &id,
                                                      double x) {
  if (!m_model)
    return false;

  int index = m_model->getIndexFromId(id);
  if (index < 0)
    return false;

  return m_model->setData(m_model->index(index), x, SensorModel::XRole);
}

Q_INVOKABLE bool SensorController::setSensorPositionY(const QUuid &id,
                                                      double y) {
  if (!m_model)
    return false;

  int index = m_model->getIndexFromId(id);
  if (index < 0)
    return false;

  return m_model->setData(m_model->index(index), y, SensorModel::YRole);
}
