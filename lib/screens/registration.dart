import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/forget_password.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { signup, login }

class Registration extends StatefulWidget {
  const Registration({super.key});
  static const routeName = '/registration';

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  var isLoading = false;
  AuthMode _authMode = AuthMode.login;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
    'confirm': ''
  };

  Widget welcomeLable() {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: size.height * 0.07, horizontal: size.height * 0.15),
      child: Column(
        children: [
          Text(
            "Welcome!",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Divider(
            thickness: 2,
            color: Theme.of(context).colorScheme.surface,
          ),
          const Text("Brana Note"),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).colorScheme.background,
        title: Text('An Error Occurred!',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            )),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Okay',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) {
      //error
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false)
            .signIn(_authData['email']!, _authData['password']!);

        // ignore: use_build_context_synchronously
        await Provider.of<Auth>(context, listen: false)
            .getUserDataFromPreference();
      } else {
        // sign user up

        await Provider.of<Auth>(context, listen: false).singUp(
            _authData['name']!, _authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height - MediaQuery.of(context).padding.top,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.08,
              ),
              welcomeLable(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size.height * 0.07),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          (_authMode == AuthMode.signup) ? "Sign up" : "Login",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        if (_authMode == AuthMode.signup)
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The name is empty";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _authData['name'] = newValue!;
                            },
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: size.width * 0.03,
                                  horizontal: size.width * 0.04),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(size.width * 0.04),
                                  ),
                                  gapPadding: 4.0),
                              enabled:
                                  _authMode == AuthMode.signup ? true : false,
                              hintText: "Full Name",
                              hintStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: size.height * 0.013,
                              ),
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.onBackground,
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFormField(
                          initialValue: '',
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            height: size.height * 0.001,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            _authData['email'] = newValue!;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(size.width * 0.04),
                                ),
                                gapPadding: 4.0),

                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: size.height * 0.013,
                            ),
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.onBackground,
                            // helperText: "Password",
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFormField(
                          textInputAction: (_authMode == AuthMode.signup)
                              ? TextInputAction.next
                              : TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 8) {
                              return 'Password is too short!';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _authData['password'] = newValue!;
                          },
                          style: TextStyle(
                            height: size.height * 0.001,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(size.width * 0.04),
                                ),
                                gapPadding: 4.0),
                            hintText: "password",
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: size.height * 0.013,
                            ),

                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.onBackground,
                            // helperText: "full name",
                          ),
                          obscureText: true,
                          controller: _passwordController,
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        if (_authMode == AuthMode.login)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(ForgetPassword.routeName);
                                },
                                child: Text(
                                  'Forget Password',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ],
                          ),
                        if (_authMode == AuthMode.signup)
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            },
                            style: TextStyle(
                              height: size.height * 0.001,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(size.width * 0.04),
                                  ),
                                  gapPadding: 4.0),
                              enabled:
                                  _authMode == AuthMode.signup ? true : false,
                              hintText: "Conifrm Password",
                              hintStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: size.height * 0.013,
                              ),
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.onBackground,
                            ),
                            obscureText: true,
                          ),
                        const SizedBox(
                          height: 30,
                        ),
                        isLoading
                            ? CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Theme.of(context)
                                              .colorScheme
                                              .surface),
                                  foregroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                ),
                                onPressed: () => _save(),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ),
                        TextButton(
                            style: ButtonStyle(
                                foregroundColor: MaterialStateColor.resolveWith(
                                    (states) =>
                                        Theme.of(context).colorScheme.surface)),
                            onPressed: () {
                              setState(() {
                                _switchAuthMode();
                              });
                            },
                            child: Text(
                              _authMode == AuthMode.signup
                                  ? "Have an account"
                                  : "Dont't have an account",
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
