import 'package:zero/core/models/device_model.dart';
import 'package:zero/core/models/response_model.dart';
import 'package:zero/core/services/api_service.dart';
import 'package:zero/core/utils/utils.dart';

// Get the list of devices connected to server
Future<List<Device>> getDeviceResponse() async {
  try {
    // Get the generic response of server
    Response response =
        await apiService.doGet('/devices/devices_no_repositories');
    // Get the data result
    var deviceItems = response.data['devices_result'] as List;
    // Convert the data result to list of devices
    List<Device> result = deviceItems.map((i) => Device.fromJson(i)).toList();
    return result;
  } catch (e) {
    // If error return null
    return null;
  }
}

// Get the status of the device connected
Future<DeviceStatus> getStatusDevice(String deviceName) async {
  try {
    // First, check if it's acquiring with the name of the device
    Future<Response> futureResponse =
        apiService.doGet('/acquire/device/' + deviceName.split("/")[2]);
    // Get the generic response of server
    Response response = await futureResponse;

    // If data, it's acquiring
    if (response.data != null) {
      // Convert the data result to device status ACQUIRING
      return DeviceStatus.fromJson(response.data, DeviceOperation.ACQUIRING);
    }

    // If not acquiring, check if it's processing a forensic module with the name of the device
    futureResponse =
        apiService.doGet('/forensic/device' + '/' + deviceName.split("/")[2]);
    // Get the generic response of server
    response = await futureResponse;

    // If data, it's processing a module
    if (response.data != null) {
      // Convert the data result to device status RUNNING_MODULE
      return DeviceStatus.fromJson(
          response.data, DeviceOperation.RUNNING_MODULE);
    }

    // If not acquiring or processing module, return WAITING
    return DeviceStatus(operation: DeviceOperation.WAITING);
  } catch (e) {
    // If error return null
    return null;
  }
}

// Check if exist repositories on the server
Future<bool> hasRepositories() async {
  try {
    // Get the generic response of server
    Response response = await apiService.doGet('/devices/repositories');
    // Get the data result
    var repositoriesItems = response.data['repositories_result'] as List;
    return repositoriesItems.length > 0;
  } catch (e) {
    // If error return null
    return null;
  }
}

// Start a acquisition of the device
Future<DeviceStatus> acquireDevice(Device device) async {
  try {
    Map acquisition = {
      'device': device.name,
      'method': 'ewf', // TODO: Obtener el metodo de settings
      'alias': CoreUtils.generateAliasAcquisition(device.name)
    };

    Future<Response> futureResponse =
        apiService.doPostJson('/acquire', acquisition);
    Response response = await futureResponse;

    // If data, it's acquiring
    if (response.data.isNotEmpty) {
      return DeviceStatus.fromJson(response.data, DeviceOperation.ACQUIRING);
    }
  } catch (e) {
    print(e);
  }

  // If not data, device is waiting
  return new DeviceStatus(operation: DeviceOperation.WAITING);
}

// Get the status of an acquisition
Future<DeviceStatus> getAcquireStatus(String acquireId) async {
  try {

    // Get the status of an acquisition by the id
    Future<Response> futureResponse =
    apiService.doGet('/acquire/' + acquireId);
    // Get the generic response of server
    Response response = await futureResponse;

    // If data, it's acquiring
    if (response.data != null) {
      // Convert the data result to device status
      DeviceStatus result = DeviceStatus.fromJson(response.data);
      if (result.operationStatus == DeviceServerStatus.RUNNING) {
        result.setDeviceOperation(DeviceOperation.ACQUIRING);
      } else {
        result.setDeviceOperation(DeviceOperation.WAITING);
      }

      return result;
    }

  } catch (e) {
    print(e);
  }

  // If not data, device is waiting
  return new DeviceStatus(operation: DeviceOperation.WAITING);
}

// Get the list of forensic modules
Future<List<String>> getForensicModules() async {
  List<String> modules = new List<String>();
  try {
    Response response = await apiService.doGet('/forensic');
    if (response.data != null) {
      var modulesItems = response.data['module_list'] as List;
      modules = modulesItems.map((i) => i.toString()).toList();
    }
  } catch (e) {
    return null;
  }
  return modules;
}

// Run a forensic module of a device
Future<DeviceStatus> runModule(String deviceName, String module) async {
  try {
    Map runModule = {
      'device': deviceName,
      'module': module
    };

    Future<Response> futureResponse = apiService.doPostJson('/forensic', runModule);
    Response response = await futureResponse;

    // If data, it's acquiring
    if (response.data.isNotEmpty) {
      return DeviceStatus.fromJson(response.data, DeviceOperation.RUNNING_MODULE);
    }
  } catch (e) {
    print(e);
  }

  // If not data, device is waiting
  return new DeviceStatus(operation: DeviceOperation.WAITING);
}

// Get the status of an forensic execution
Future<DeviceStatus> getModuleStatus(String executionId) async {
  try {

    // Get the status of an forensic execution by the id
    Future<Response> futureResponse =
    apiService.doGet('/forensic/task/' + executionId);
    // Get the generic response of server
    Response response = await futureResponse;

    // If data, it's executing a module
    if (response.data != null) {
      // Convert the data result to device status
      DeviceStatus result = DeviceStatus.fromJson(response.data);
      if (result.operationStatus == DeviceServerStatus.RUNNING) {
        result.setDeviceOperation(DeviceOperation.RUNNING_MODULE);
      } else {
        result.setDeviceOperation(DeviceOperation.WAITING);
      }

      return result;
    }

  } catch (e) {
    print(e);
  }

  // If not data, device is waiting
  return new DeviceStatus(operation: DeviceOperation.WAITING);
}

// Get the result of an forensic execution
Future<String> getModuleResult(String executionId) async {
  String result = "";

  try {
    // Get the result of an forensic execution by the id
    Future<Response> futureResponse =
    apiService.doGet('/forensic/task/' + executionId);
    // Get the generic response of server
    Response response = await futureResponse;

    // If data, it's executing a module
    if (response.data != null) {
      // Convert the data result to result
      String result = response.data['result'] as String;
      return result;
    }

  } catch (e) {
    print(e);
  }

  // If not data, return empty
  return result;
}