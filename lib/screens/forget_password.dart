// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = '/forgetPassword';
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Password Reset'),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.secondary,
            ),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * 0.07),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your email then we we will send you password reset link',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Invalid email!';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              onSaved: (newValue) {},
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: size.width * 0.03, horizontal: size.width * 0.04),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSecondary),
                    borderRadius: BorderRadius.all(
                      Radius.circular(size.width * 0.04),
                    ),
                    gapPadding: 4.0),
                hintText: "Email",
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontSize: size.height * 0.013,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            MaterialButton(
              onPressed: () async {
                try {
                  await Provider.of<Auth>(context, listen: false)
                      .resetPassword(_emailController.text.trim());
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        content: SizedBox(
                          height: size.height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'We\'ve sent you a link please check your email',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'okay',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } on HttpException catch (e) {
                  final result = e;

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        content: SizedBox(
                          height: size.height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                result.toString(),
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'okay',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        content: SizedBox(
                          height: size.height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('An error occured please try agai later',
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'okay',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              color: Theme.of(context).colorScheme.surface,
              child: Text(
                'Send',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            )
          ],
        ),
      ),
    );
  }
}
