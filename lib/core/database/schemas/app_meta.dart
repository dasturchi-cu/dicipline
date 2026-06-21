import 'package:isar/isar.dart';

part 'app_meta.g.dart';

@collection
class AppMeta {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String key;

  late String value;
}
