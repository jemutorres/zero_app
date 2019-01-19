import 'package:quiver/core.dart';

// Settings of zero
class SettingsZero {
  String ipServer;
  List<String> repositories;
  String defaultRepository;
  List<String> acquireTypes;
  String defaultAcquireType;

  SettingsZero({this.ipServer, this.repositories, this.defaultRepository, this.acquireTypes, this.defaultAcquireType});

  bool operator ==(o) => o is SettingsZero && ipServer == o.ipServer && repositories == o.repositories && acquireTypes == o.acquireTypes;
  int get hashCode => hash3(ipServer.hashCode, ipServer.hashCode, repositories.hashCode);

}