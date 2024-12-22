import 'package:isar/isar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Generate collection file by running `dart run build_runner build`
part 'options.g.dart';

@Collection()
class Options {
  Id id = 1;
  bool? beep;
  bool? vibrate;
  bool? copyToClipboard;
  bool? flash;
  
  @enumerated
  DetectionSpeed detectionSpeed = DetectionSpeed.normal;

  @enumerated
  CameraFacing facing = CameraFacing.back;

  // QR code generation options
  int? qrSize;
  bool? qrTransparent;

  // Theme
  int? theme;
}