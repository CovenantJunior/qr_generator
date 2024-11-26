import 'package:isar/isar.dart';

// Generate collection file by running `dart run build_runner build`
part 'options.g.dart';

@Collection()
class Options {
  Id id = 1;
  bool? darkMoode;
  bool? beep;
  bool? vibrate;
  bool? copyToClipboard;
  String? detectionSpeed;
  String? facing;
  bool? flash;

  // QR code generation options
  int? qrSize;
  bool? qrTransparent;
}