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
        ..qrTransparent = false
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

  setBeep() async {
    var initOptions = await isar.options.get(1);
    if (initOptions != null) {
      if (initOptions.beep == true) {
        initOptions.beep = false;
      } else {
        initOptions.beep = true;
      }
      await isar.writeTxn(() => isar.options.put(initOptions));
      options.first.beep = initOptions.beep;
    }
    fetchOptions();
  }

  setVibrations() async {
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

  setClipboard() async {
    var initOptions = await isar.options.get(1);
    if (initOptions != null) {
      if (initOptions.copyToClipboard == true) {
        initOptions.copyToClipboard = false;
      } else {
        initOptions.copyToClipboard = true;
      }
      await isar.writeTxn(() => isar.options.put(initOptions));
      options.first.copyToClipboard = initOptions.copyToClipboard;
    }
    fetchOptions();
  }

  setDetectionSpeed() async {
    var initOptions = await isar.options.get(1);
    if (initOptions != null) {
      if (initOptions.detectionSpeed == DetectionSpeed.unrestricted) {
        initOptions.detectionSpeed = DetectionSpeed.normal;
      } else if (initOptions.detectionSpeed == DetectionSpeed.normal) {
        initOptions.detectionSpeed = DetectionSpeed.noDuplicates;
      } else {
        initOptions.detectionSpeed = DetectionSpeed.unrestricted;
      }
      await isar.writeTxn(() => isar.options.put(initOptions));
      options.first.detectionSpeed = initOptions.detectionSpeed;
    }
    fetchOptions();
  }

  setCamera() async {
    var initOptions = await isar.options.get(1);
    if (initOptions != null) {
      if (initOptions.facing == CameraFacing.back) {
        initOptions.facing = CameraFacing.front;
      } else {
        initOptions.facing = CameraFacing.back;
      }
      await isar.writeTxn(() => isar.options.put(initOptions));
      options.first.facing = initOptions.facing;
    }
    fetchOptions();
  }

  setFlash() async {
    var initOptions = await isar.options.get(1);
    if (initOptions != null) {
      if (initOptions.flash == true) {
        initOptions.flash = false;
      } else {
        initOptions.flash = true;
      }
      await isar.writeTxn(() => isar.options.put(initOptions));
      options.first.flash = initOptions.flash;
    }
    fetchOptions();
  }

  setQRSize(size) async {
    var initOptions = await isar.options.get(1);
    if (initOptions != null) {
      initOptions.qrSize = size;
      await isar.writeTxn(() => isar.options.put(initOptions));
      options.first.qrSize = initOptions.qrSize;
    }
    fetchOptions();
  }

  setTransparent() async {
    var initOptions = await isar.options.get(1);
    if (initOptions != null) {
      if (initOptions.qrTransparent == true) {
        initOptions.qrTransparent = false;
      } else {
        initOptions.qrTransparent = true;
      }
      await isar.writeTxn(() => isar.options.put(initOptions));
      options.first.qrTransparent = initOptions.qrTransparent;
    }
    fetchOptions();
  }
}