import 'package:zero/core/models/repository_model.dart';
import 'package:zero/core/models/response_model.dart';
import 'package:zero/core/services/api_service.dart';

Future<List<Repository>> getRepositories() async {
  try {
    // Get repositories
    Response response = await apiService.doGet('/devices/repositories');
    var repositoryItems = response.data['repositories_result'] as List;
    List<Repository> repositories = repositoryItems.map((i) => Repository.fromJson(i)).toList();
    return repositories;
  } catch (e) {
    return null;
  }
}

Future<bool> shutdownServer() async {
  try {
    // Get repositories
    Response response = await apiService.doGet('/shutdown');
    bool isShutdown = response.data['repositories_result'] as bool;
    return isShutdown;
  } catch (e) {
    return false;
  }
}
