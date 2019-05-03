import 'package:equatable/equatable.dart';

abstract class AbstractModel extends Equatable {
  int id;

  AbstractModel();

  AbstractModel.fromJson(Map<String, dynamic> data);

  @override
  bool operator ==(Object other) => other is AbstractModel && id == other.id;
}
