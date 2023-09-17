import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

import '../providers/setting.dart';
import "../screens/confirmation_email.dart";
import "../screens/forget_password.dart";
import "../screens/registration.dart";
import 'screens/settings_screen.dart';
import "../providers/notes.dart";
import "../providers/qoutes.dart";
import 'screens/edit_new_screen.dart';
import "./screens/dashboard.dart";
import "../providers/auth.dart";
import './screens/onboarding.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: []);
  runApp(
      const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Notes>(
          update: (context, auth, previous) => Notes.proxy(
            auth.token,
            auth.userId,
            previous == null ? [] : previous.notes,
          ),
          create: (BuildContext context) {
            return Notes('create');
          },
        ),
        ChangeNotifierProxyProvider<Auth, Qoutes>(
          create: (context) => Qoutes(),
          update: (context, auth, previous) => Qoutes.proxy(
            previous == null ? [] : previous.qoutes,
            auth.userId,
            auth.token,
          ),
        ),
        ChangeNotifierProvider.value(value: Setting()),
      ],
      child: Consumer<Auth>(builder: (context, auth, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const WelcomeScreen(),
          routes: {
            'startPage': (context) => auth.isAuth
                ? auth.isEmailVrefied
                    ? const DashBoard()
                    :  const ConfirmationMessage()
                : const Registration(),
            EditNewScreen.routeName: (_) => const EditNewScreen(),
            DashBoard.routeName: (_) => const DashBoard(),
            Settings.routeName: (_) => const Settings(),
            ForgetPassword.routeName: (_) => const ForgetPassword(),
            ConfirmationMessage.routeName: (_) => const ConfirmationMessage(),
            OnBoarding.routeName: (_) => const OnBoarding(),
          },
          theme: ThemeData(
              drawerTheme: DrawerThemeData(
                  backgroundColor:
                      Provider.of<Setting>(context).isDarkModeEnabled
                          ? const Color.fromARGB(182, 51, 51, 51)
                          : const Color.fromARGB(128, 178, 174, 191)),
              appBarTheme: AppBarTheme(
                foregroundColor: Provider.of<Setting>(context).isDarkModeEnabled
                    ? const Color.fromRGBO(51, 51, 51, 1)
                    : const Color.fromARGB(255, 255, 255, 220),
                color: Provider.of<Setting>(context).isDarkModeEnabled
                    ? const Color.fromRGBO(51, 51, 51, 1)
                    : const Color.fromARGB(255, 255, 255, 220),
              ),
              tabBarTheme: TabBarTheme(
                labelColor: Provider.of<Setting>(context).isDarkModeEnabled
                    ? const Color.fromARGB(255, 247, 244, 244)
                    : const Color.fromARGB(255, 10, 5, 30),
                unselectedLabelColor: const Color.fromARGB(143, 255, 255, 255),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 3,
                    color: Provider.of<Setting>(context).isDarkModeEnabled
                        ? const Color.fromARGB(255, 10, 5, 30)
                        : const Color.fromARGB(255, 247, 244, 244),
                  ),
                ),
                dividerColor: null,
              ),
              colorScheme: ColorScheme(
                  background: Provider.of<Setting>(context).isDarkModeEnabled
                      ? const Color.fromRGBO(51, 51, 51, 1)
                      : const Color.fromARGB(255, 255, 255, 220),
                  onBackground: Provider.of<Setting>(context).isDarkModeEnabled
                      ? const Color.fromARGB(49, 211, 211, 211)
                      : const Color.fromARGB(30, 72, 72, 72),
                  primary: Provider.of<Setting>(context).isDarkModeEnabled
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 255, 255, 255),
                  onPrimary: Provider.of<Setting>(context).isDarkModeEnabled
                      ? const Color.fromARGB(132, 176, 170, 163)
                      : const Color.fromARGB(132, 38, 35, 32),
                  brightness: Brightness.light,
                  secondary: Provider.of<Setting>(context).isDarkModeEnabled
                      ? const Color.fromARGB(255, 247, 244, 244)
                      : const Color.fromARGB(255, 10, 5, 30),
                  onSecondary: Provider.of<Setting>(context).isDarkModeEnabled
                      ? const Color.fromARGB(166, 247, 244, 244)
                      : const Color.fromARGB(163, 17, 8, 8),
                  error: Colors.red,
                  onError: const Color.fromARGB(155, 244, 67, 54),
                  surface: Provider.of<Setting>(context).isDarkModeEnabled
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : const Color.fromARGB(255, 0, 0, 0),
                  onSurface: const Color.fromRGBO(255, 255, 255, 0.631)),
              textTheme: TextTheme(
                titleLarge: TextStyle(
                    color: Provider.of<Setting>(context).isDarkModeEnabled
                        ? const Color.fromRGBO(208, 208, 208, 1)
                        : const Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 20,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold),
                titleMedium: TextStyle(
                    color: Provider.of<Setting>(context).isDarkModeEnabled
                        ? const Color.fromRGBO(208, 208, 208, 1)
                        : const Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 20,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold),
                titleSmall: TextStyle(
                    color: Provider.of<Setting>(context).isDarkModeEnabled
                        ? const Color.fromRGBO(208, 208, 208, 1)
                        : const Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 16,
                    fontFamily: "Lato"),
                bodyLarge: TextStyle(
                    color: Provider.of<Setting>(context).isDarkModeEnabled
                        ? const Color.fromRGBO(208, 208, 208, 1)
                        : const Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Rubik"),
                bodyMedium: TextStyle(
                    color: Provider.of<Setting>(context).isDarkModeEnabled
                        ? const Color.fromRGBO(208, 208, 208, 1)
                        : const Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 16,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.normal),
                bodySmall: TextStyle(
                  color: Provider.of<Setting>(context).isDarkModeEnabled
                      ? const Color.fromRGBO(208, 208, 208, 1)
                      : const Color.fromRGBO(51, 51, 51, 1),
                  fontFamily: "Rubik",
                ),
              ),
              buttonTheme: ButtonThemeData(
                hoverColor: const Color.fromRGBO(255, 190, 125, 1),
                buttonColor: const Color.fromRGBO(0, 0, 0, 1),
                splashColor: Provider.of<Setting>(context).isDarkModeEnabled
                    ? const Color.fromRGBO(255, 255, 255, 1)
                    : const Color.fromARGB(255, 0, 0, 0),
              ),
              dialogTheme: DialogTheme(
                backgroundColor: Theme.of(context).colorScheme.background,
                contentTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 16,
                ),
              ),
              snackBarTheme: SnackBarThemeData(
                  backgroundColor: Theme.of(context).colorScheme.secondary),
              hintColor: Provider.of<Setting>(context).isDarkModeEnabled
                  ? const Color.fromARGB(255, 0, 0, 0)
                  : const Color.fromRGBO(255, 255, 255, 1),
              searchBarTheme: SearchBarThemeData(
                  backgroundColor:
                      MaterialStatePropertyAll(Theme.of(context).colorScheme.background))),
        );
      }),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    autoLogin();

    goToNextScreen();
    super.initState();
  }

  void autoLogin() async {
    await Provider.of<Auth>(context, listen: false).autoLogin();
  }

  Future<bool> isFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }

    return isFirstTime;
  }

  void goToNextScreen() async {
    final isFirstTime = await isFirstTimeUser();
    Future.delayed(const Duration(seconds: 2), () {
      isFirstTime
          ? Navigator.of(context).pushReplacementNamed(OnBoarding.routeName)
          : Navigator.of(context).pushReplacementNamed('startPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Auth>(context, listen: false).getUserDataFromPreference();

    return Center(
      child: Image.asset('asset/svg/brana.png'),
    );
  }
}
