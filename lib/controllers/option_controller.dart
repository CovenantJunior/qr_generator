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
        ..beep = true
        ..vibrate = true
        ..copyToClipboard = false
        ..detectionSpeed = DetectionSpeed.normal
        ..facing = CameraFacing.back
        ..flash = false
        ..qrSize = 200
        ..qrTransparent = true
        ..theme = 1;
      await isar.writeTxn(() => isar.options.put(newPreference));
    }
    options = isar.options.where().findAllSync();
    notifyListeners();
  }

  void fetchOptions() async {
    List<Options> currentOptions = isar.options.where().findAllSync();
    if (currentOptions.isEmpty) {
      initOptions();
    } else {
      options.clear();
      options.addAll(currentOptions);
      notifyListeners();
    }
  }

  void updateTheme(id) async {
    var initOptions = await isar.options.get(1);
    if (initOptions != null) {
      if (initOptions.theme == id) {
        
      } else {
        initOptions.theme = id;
      }
      await isar.writeTxn(() => isar.options.put(initOptions));
      options.first.theme = initOptions.theme;
    }
    fetchOptions();
  }

  setVibrations(dynamic isar) async {
    var initOptions = await isar.options.get(1);
    if (initOptions != null) {
      if (initOptions.vibrate == true) {
        initOptions.vibrate = false;
      } else {
        initOptions.vibrate = true;
      }
      await isar.writeTxn(() => isar.options.put(initOptions));
      options.first.vibrate = initOptions.vibrate;
    }
    fetchOptions();
  }
}