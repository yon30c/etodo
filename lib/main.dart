import 'package:etodo/src/config/theme/theme_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/config/notifications/notifications.dart';
import 'src/config/theme/theme_controller.dart';

final themeController = ThemeController(ThemeService());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await LocalNotifications.initializeNotification();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  await ThemeService.init();

  await themeController.loadTheme();

  runApp(ProviderScope(
      child: MainApp(
    themeController: themeController,
  )));
}
