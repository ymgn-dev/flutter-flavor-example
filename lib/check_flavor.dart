import 'package:enum_to_string/enum_to_string.dart';

enum Flavor { development, staging, production, unknown }

Flavor flavor = (() {
  final flavor = EnumToString.fromString(
    Flavor.values,
    const String.fromEnvironment('FLAVOR'),
  );
  return flavor ?? Flavor.unknown;
})();
