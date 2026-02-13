#include "SensorModel.h"

SensorModel::SensorModel(QObject *parent) : QAbstractListModel(parent) {}

int SensorModel::rowCount(const QModelIndex &parent) const {
  Q_UNUSED(parent)
  return m_sensors.size();
}

QVariant SensorModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() < 0 || index.row() >= m_sensors.size())
    return QVariant();

  const Sensor &sensor = m_sensors[index.row()];

  switch (role) {
  case IdRole:
    return sensor.id;
  case NameRole:
    return sensor.name;
  case InputRole:
    return sensor.inputValue;
  case ThresholdRole:
    return sensor.threshold;
  case OperatorRole:
    return sensor.selectedOperator;
  case XRole:
    return sensor.x;
  case YRole:
    return sensor.y;
  }
  return QVariant();
}

bool SensorModel::setData(const QModelIndex &index, const QVariant &value,
                          int role) {
  if (!index.isValid() || index.row() < 0 || index.row() >= m_sensors.size())
    return false;

  Sensor &sensor = m_sensors[index.row()];
  bool changed = false;

  switch (role) {
  case NameRole:
    if (sensor.name != value.toString()) {
      sensor.name = value.toString();
      changed = true;
    }
    break;
  case InputRole:
    if (sensor.inputValue != value.toDouble()) {
      sensor.inputValue = value.toDouble();
      changed = true;
    }
    break;
  case ThresholdRole:
    if (sensor.threshold != value.toDouble()) {
      sensor.threshold = value.toDouble();
      changed = true;
    }
    break;
  case OperatorRole:
    if (sensor.selectedOperator != value.toString()) {
      sensor.selectedOperator = value.toString();
      changed = true;
    }
    break;
  case XRole:
    if (sensor.x != value.toDouble()) {
      sensor.x = value.toDouble();
      changed = true;
    }
    break;
  case YRole:
    if (sensor.y != value.toDouble()) {
      sensor.y = value.toDouble();
      changed = true;
    }
    break;
  default:
    return false;
  }

  if (changed) {
    emit dataChanged(index, index, {role});
  }

  return changed;
}

QHash<int, QByteArray> SensorModel::roleNames() const {
  static const QHash<int, QByteArray> mapping{
      {IdRole, "id"},
      {NameRole, "name"},
      {InputRole, "inputValue"},
      {ThresholdRole, "threshold"},
      {OperatorRole, "selectedOperator"},
      {XRole, "x"},
      {YRole, "y"}};
  return mapping;
}

QUuid SensorModel::addSensor() {
  beginInsertRows(QModelIndex(), m_sensors.size(), m_sensors.size());

  Sensor sensor;
  sensor.name = "No Name Set";
  sensor.inputValue = 0.0;
  sensor.threshold = 100.0;
  sensor.selectedOperator = "==";
  sensor.x = 0;
  sensor.y = 0;

  m_sensors.append(sensor);

  endInsertRows();
  emit sensorAdded(sensor.id);
  emit countChanged();
  return sensor.id;
}

bool SensorModel::removeSensor(const QUuid &id) {
  int i = getIndexFromId(id);
  if (i < 0) {
    qWarning() << "Attempted to remove non-existent sensor with id:" << id;
    return false;
  }

  beginRemoveRows({}, i, i);

  m_sensors.removeAt(i);

  endRemoveRows();

  emit sensorRemoved(id);
  emit countChanged();
  return true;
}

int SensorModel::getIndexFromId(const QUuid &id) const {
  for (int i = 0; i < m_sensors.size(); ++i)
    if (m_sensors[i].id == id)
      return i;
  return -1;
}
