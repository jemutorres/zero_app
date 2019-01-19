import 'package:zero/core/models/device_model.dart';

class Repository extends Device {
  final String mountPoint;

  Repository({String name, int sizeTotal, int sizeUsed, this.mountPoint})
      : super(name: name, sizeTotal: sizeTotal, sizeUsed: sizeUsed);

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
        name: json['name'],
        sizeTotal: json['total_size'],
        sizeUsed: json['used_size'],
        mountPoint: json['mount_point']);
  }
}
