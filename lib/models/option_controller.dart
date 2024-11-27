import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_generator/models/options.dart';

class OptionController extends ChangeNotifier{
  static late Isar isar;

  // Initialize DB
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [OptionsSchema],
      directory: dir.path
    );
  }

  List<Options> options = [];

  void initOptions() async {
    List currentOptions = isar.options.where().findAllSync();
    if (currentOptions.isEmpty) {
      final newPreference = Options()
        ..darkMode = false
        ..beep = true
        ..vibrate = true
        ..copyToClipboard = false
        ..detectionSpeed = DetectionSpeed.normal
        ..facing = CameraFacing.back
        ..flash = false
        ..qrSize = 200
        ..qrTransparent = true;
      await isar.writeTxn(() => isar.options.put(newPreference));
    }
    options = isar.options.where().findAllSync();
    notifyListeners();
  }
}