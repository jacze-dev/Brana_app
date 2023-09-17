// ignore_for_file: use_build_context_synchronously

import 'package:brana_app/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth.dart';

import '../models/http_exception.dart';

class ConfirmationMessage extends StatefulWidget {
  const ConfirmationMessage({super.key});
  static const routeName = '/confirmationScreen';

  @override
  State<ConfirmationMessage> createState() => _ConfirmationMessageState();
}

class _ConfirmationMessageState extends State<ConfirmationMessage> {
  bool isLoading = false;
  @override
  void initState() {
    checkEmailVerfication();
    super.initState();
  }

  void startEmailSending() async {
    await Provider.of<Auth>(context, listen: false).sendConfirmEmail();
  }

  void checkEmailVerfication() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<Auth>(context, listen: false).getUserData();
    startEmailSending();
    Future.delayed(const Duration(seconds: 2), () {
      bool isVerfied = Provider.of<Auth>(context).isEmailVrefied;
      if (isVerfied) {
        startEmailSending();
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void _showAlert(String content) {
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          content: SizedBox(
            height: size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('An error occured please try again later',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Text(content,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall),
                SizedBox(
                  height: size.height * 0.03,
                ),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'okay',
                      style: Theme.of(context).textTheme.titleSmall,
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return isLoading
        ? const LoadingPage()
        : Scaffold(
            appBar: AppBar(
              leading: TextButton(
                  onPressed: () async {
                    await Provider.of<Auth>(context, listen: false).logout();
                    Navigator.of(context).pushReplacementNamed('startPage');
                  },
                  child: Text(
                    'Back',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
              title: const Text('Confirmation Messgae'),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.15,
                  ),
                  Text(
                    'We\'ve sent you a confirmation email! Please check your inbox for an email from us. Click the link provided in the email to complete the verification process and get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  InkWell(
                    onTap: () {
                      try {
                        setState(() async {
                          await Provider.of<Auth>(context, listen: false)
                              .confirmEmail();
                          if (Provider.of<Auth>(context).isEmailVrefied) {
                            _showAlert('please check your email !');
                          }
                        });
                      } catch (e) {
                        rethrow;
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.secondary),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.05)),
                      child: TextButton(
                        onPressed: () async {
                          try {
                            await Provider.of<Auth>(context, listen: false)
                                .confirmEmail();
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          result.toString(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.03,
                                        ),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(
                                              'okay',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } catch (e) {
                            _showAlert('');
                          }
                        },
                        child: Text(
                          'Get started',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  MaterialButton(
                      onPressed: () async {
                        try {
                          await Provider.of<Auth>(context, listen: false)
                              .sendConfirmEmail();
                        } on HttpException catch (e) {
                          _showAlert(e.message);
                        } catch (e) {
                          _showAlert('');
                        }
                      },
                      color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        'Resend',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background),
                      )),
                ],
              ),
            ),
          );
  }
}
