import 'package:uuid/uuid.dart';

typedef EntityId = String;

final class AppId {
  AppId._();

  static const Uuid _uuid = Uuid();

  static EntityId generate() => _uuid.v4();
}
