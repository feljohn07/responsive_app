import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/services.dart';


windowFullScreen(bool isHidden) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Must add this line.
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: isHidden ? TitleBarStyle.hidden : TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setFullScreen(isHidden);
    });
  } on MissingPluginException {
    print('windowManager: MissingPluginException');
  } catch (e) {
    print(e);
  }
}
