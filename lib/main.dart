import 'package:ems/persistence/current_user.dart';
import 'package:ems/persistence/setting.dart';
import 'package:ems/screens/attendance/individual_attendance.dart';
import 'package:ems/screens/employee/employee_info_screen.dart';
import 'package:ems/screens/home_screen.dart';
import 'package:ems/screens/home_screen_employee.dart';
import 'package:ems/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import './constants.dart';
import './screens/employee/employee_list_screen.dart';
import 'l10n/l10n.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializing local database
  final dataStore = CurrentUserStore();
  final settingsStore = SettingsStore();
  await dataStore.init();
  await settingsStore.init();

  runApp(
    ProviderScope(
      overrides: [
        currentUserProvider.overrideWithValue(dataStore),
        settingsProvider.overrideWithValue(settingsStore),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ValueListenableBuilder(
        valueListenable: ref.watch(settingsProvider).settingsListenable,
        builder: (BuildContext context, Box<int> box, Widget? child) {
          int index = box.values.toList()[0];

          return MaterialApp(
            locale: L10n.all[index],
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: themeData(context),
            home: ValueListenableBuilder(
              valueListenable:
                  ref.watch(currentUserProvider).currentUserListenable,
              builder: (BuildContext context, Box<User> box, Widget? child) {
                final currentUserData = box.values.toList();
                return box.isEmpty || currentUserData[0].isEmpty
                    ? const LoginScreen()
                    : currentUserData[0].role?.toLowerCase() == 'admin'
                        ? const HomeScreenAdmin()
                        : const HomeScreenEmployee();
              },
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            routes: {
              IndividualAttendanceScreen.routeName: (ctx) =>
                  IndividualAttendanceScreen(),
              // EmployeeEditScreen.routeName: (ctx) => EmployeeEditScreen(),
              EmployeeInfoScreen.routeName: (ctx) => EmployeeInfoScreen(),
              EmployeeListScreen.routeName: (ctx) => EmployeeListScreen(),
            },
          );
        });
  }
}
