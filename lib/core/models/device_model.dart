import 'package:quiver/core.dart';

// Device processing
enum DeviceOperation { ACQUIRING, RUNNING_MODULE, WAITING }

// Device operation status in the server
enum DeviceServerStatus { RUNNING, FINISHED, FAILED, IDLE }

// Device connected to zero server
class Device {
  final String name;
  final int sizeTotal;
  final int sizeUsed;
  DeviceStatus status = new DeviceStatus();
  Map<String, List<String>> results = new Map<String, List<String>>();

  Device({this.name, this.sizeTotal, this.sizeUsed});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
        name: json['name'],
        sizeTotal: json['total_size'],
        sizeUsed: json['used_size']);
  }

  // Set device status
  void setDeviceStatusResponse(DeviceStatus status) {
    this.status = status;
  }

  // Get results of module
  List<String> getModulesExecuted() {
    return results.keys.toList();
  }

  // Get results of module
  List<String> getResultModule(String module) {
    return results[module];
  }

  // Add result of module
  void setResultModule(String module, String id) {
    if(results[module] == null) {
      results[module] = new List<String>();
    }

    results[module].add(id);
  }

  // Get if devices has results of forensic modules
  bool existResults() {
    return results.length > 0;
  }

  // Compare objects
  bool operator ==(o) => o is Device && name == o.name && sizeTotal == o.sizeTotal && sizeUsed == o.sizeUsed;
  int get hashCode => hash4(name.hashCode, sizeTotal.hashCode, sizeUsed.hashCode, status.hashCode);
}

// Device status
// If DeviceOperation.WAITING -> empty values
// If DeviceOperation is different to WAITING, it's have id, progress and operationStatus
class DeviceStatus {
  final String id;
  final int progress;
  final String module;
  DeviceOperation operation;
  final DeviceServerStatus operationStatus;

  DeviceStatus({this.id, this.progress, this.module, this.operation, this.operationStatus});

  factory DeviceStatus.fromJson(Map<String, dynamic> json,
      [DeviceOperation operation = DeviceOperation.WAITING]) {
    return DeviceStatus(
        id: json['id'],
        progress: json['progress'],
        module: json['module'],
        operation: operation,
        operationStatus: DeviceServerStatus.values.firstWhere((e) =>
            e.toString().toLowerCase() ==
            ("DeviceServerStatus." + json['status'].toString().toUpperCase())
                .toLowerCase()));
  }

  // Set device operation
  void setDeviceOperation(DeviceOperation operation) {
    this.operation = operation;
  }

  bool operator ==(o) => o is DeviceStatus && id == o.id && progress == o.progress && operation == o.operation && operationStatus == o.operationStatus;
  int get hashCode => hash4(id.hashCode, progress.hashCode, operation.hashCode, operationStatus.hashCode);
}
