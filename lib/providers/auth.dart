import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth extends ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';

  String _userEmail = '';
  String _userName = '';
  late Timer _authTimer = Timer(
    Duration.zero,
    () {},
  );

  late bool _emailIsVerfied = false;

  final keyString = 'appkey';

  bool get isAuth {
    return token != '';
  }

  bool get isEmailVrefied {
    return _emailIsVerfied;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != DateTime.now() &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != '') {
      return _token;
    }
    return '';
  }

  String get userName {
    return _userName;
  }

  String get userEmail {
    return _userEmail;
  }

  // Future<void> _authenticate(
  //     String email, String password, String urlSegment) async {
  // final url =
  //     'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$keyString';
  // try {
  //   final response = await http.post(
  //     Uri.parse(url),
  //     body: json.encode(
  //       {
  //         'email': email,
  //         'password': password,
  //         'returnSecureToken': true,
  //       },
  //     ),
  //   );

  //   final responseData = json.decode(response.body);
  //   if (responseData['error'] != null) {
  //     throw HttpException(responseData['error']['message']);
  //   }

  //   _userId = responseData['localId'];
  //   _token = responseData['idToken'];
  //   _expiryDate = DateTime.now().add(
  //     Duration(
  //       seconds: int.parse(responseData['expiresIn']),
  //     ),
  //   );
  //   autoLogout();
  //   notifyListeners();

  //   final prefs = await SharedPreferences.getInstance();
  //   final userData = json.encode(
  //     {
  //       'token': _token,
  //       'userId': _userId,
  //       'emailIsVerified': _emailIsVerfied,
  //       'expiryDate': _expiryDate.toIso8601String(),
  //     },
  //   );

  //   prefs.setString('userData', userData);
  // } catch (error) {
  //   rethrow;
  // }
  // }

  addUser(String name, String email) async {
    final url =
        'https://brana-note-aaa69-default-rtdb.europe-west1.firebasedatabase.app/users/$userId.json?auth=$_token';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'user_name': name,
            'user_email': email,
          }));

      final responseUser = json.decode(response.body);
      if (responseUser['error'] != null) {
        throw HttpException(responseUser['error']['message']);
      }
    } catch (e) {
      return e;
    }
  }

  Future getUserDataFromPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('$userId userName') ?? '';
    _userEmail = prefs.getString('$userId userEmail') ?? "";
    _emailIsVerfied = prefs.getBool('emailIsVerfied') ?? false;

    notifyListeners();
  }

  Future getPersonalInfo() async {
    final url =
        'https://brana-note-aaa69-default-rtdb.europe-west1.firebasedatabase.app/users/.json?auth=$_token';
    try {
      final response = await http.get(Uri.parse(url));
      final responseUser = json.decode(response.body) as Map<String, dynamic>;
      final userData = responseUser[userId];
      final prefs = await SharedPreferences.getInstance();
      userData.values.forEach((innerMap) {
        prefs.setString('$userId userName', innerMap['user_name']);
        prefs.setString('$userId userEmail', innerMap['user_email']!);
      });

      if (responseUser['error'] != null) {
        throw HttpException(responseUser['error']['message']);
      }
    } catch (e) {
      return e;
    }
  }

  Future<void> singUp(String name, String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$keyString';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _userId = responseData['localId'];
      _token = responseData['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'emailIsVerified': _emailIsVerfied,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );

      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('$userId userName', name);
    prefs.setString('$userId userEmail', email);
  }

  Future<void> signIn(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$keyString';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _userId = responseData['localId'];
      _token = responseData['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      autoLogout();
      notifyListeners();
      await getUserData();
      await getPersonalInfo();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'emailIsVerified': _emailIsVerfied,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );

      prefs.setString('userData', userData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _emailIsVerfied = false;
    _token = '';
    _userId = '';
    _expiryDate = DateTime(2000);
    if (_authTimer !=
        Timer(
          Duration.zero,
          () {},
        )) {
      _authTimer.cancel();

      _authTimer = Timer(Duration.zero, () {});
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');

    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer !=
        Timer(
          Duration.zero,
          () {},
        )) {
      _authTimer.cancel();
    }
    final timeToExpires = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpires), () => logout());
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']!);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token']!;
    _userId = extractedUserData['userId']!;
    _emailIsVerfied = extractedUserData['emailIsVerified'];
    _expiryDate = expiryDate;

    notifyListeners();
    autoLogout();

    return true;
  }

  //password reset

  Future<void> resetPassword(String email) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$keyString';
    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'requestType': 'PASSWORD_RESET', 'email': email}));
      final result = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
      } else {
        final errorMessage = result['error']['message'];
        throw HttpException(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendConfirmEmail() async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$keyString';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({"requestType": "VERIFY_EMAIL", "idToken": token}),
      );

      final result = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
      } else {
        final errorMessage = result['error']['message'];
        throw HttpException(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> confirmEmail() async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$keyString';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({"requestType": "VERIFY_EMAIL", "idToken": token}),
      );

      final result = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        _emailIsVerfied = result['emailVerified'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('emailIsVerfied', _emailIsVerfied);
      } else {
        final errorMessage = result['error']['message']!;
        throw HttpException(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> getUserData() async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$keyString';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({"idToken": token}),
      );

      final result = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final listOfUsers = result['users']! as List<dynamic>;
        final user =
            listOfUsers.firstWhere((user) => userId == user['localId']!);
        print(user);
        _emailIsVerfied = user['emailVerified']!;
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('emailIsVerfied', _emailIsVerfied);
      } else {
        final errorMessage = result['error']['message']!;
        throw HttpException(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  bool get checkEmailVerfication {
    return _emailIsVerfied;
  }
}
