// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../providers/notes.dart';
import 'package:line_icons/line_icons.dart';
import '../screens/detail_screen.dart';

import '../providers/qoutes.dart';
import '../screens/edit_new_screen.dart';

class DialogHelper {
  //OPtion deialog box
  static Future<void> showOptionDialog(
      bool isInNote, BuildContext context, String id) async {
    final size = MediaQuery.of(context).size;
    await showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            insetAnimationCurve: Curves.bounceInOut,
            insetAnimationDuration: const Duration(seconds: 1),
            child: SizedBox(
              height: size.height * 0.4,
              width: size.width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        isInNote
                            ? Navigator.of(context)
                                .pushNamed(EditNewScreen.routeName, arguments: {
                                'isNote': true,
                                'id': id
                              }).then((value) => Navigator.of(context).pop())
                            : Navigator.of(context)
                                .pushNamed(EditNewScreen.routeName, arguments: {
                                'isNote': false,
                                'id': id
                              }).then((value) => Navigator.of(context).pop());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: size.width * 0.3,
                            child: Text(
                              'Edit',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Icon(
                            LineIcons.edit,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        ],
                      )),
                  const Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(Future(() {
                        isInNote
                            ? showConfirmDialog(context, 'Confirm Delete',
                                'Are you sure you want to delete this Note?', [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Provider.of<Notes>(context, listen: false)
                                          .delete(id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    )),
                              ])
                            : showConfirmDialog(context, 'Confirm Delete',
                                'Are you sure you want to delete this quote?', [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Provider.of<Qoutes>(context,
                                              listen: false)
                                          .delete(id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ))
                              ]);
                      }));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: size.width * 0.3,
                          child: Text(
                            'Delete',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => DetailScreen(
                                isNote: isInNote,
                                id: id,
                              )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: size.width * 0.3,
                          child: Text(
                            'Detail',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Icon(
                          Icons.details,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  TextButton(
                    onPressed: () async {
                      try {
                        Navigator.of(context).pop();
                        if (isInNote) {
                          await Provider.of<Notes>(context, listen: false)
                              .uploadOneNote(id);
                        } else {
                          await Provider.of<Qoutes>(context, listen: false)
                              .quoteOneUpload(id);
                        }
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('uploaded succesfuly!')));
                      } on HttpException catch (error) {
                        var exceptionMessage = 'unable to upload';
                        if (error.toString().contains('ITEM_EXISTS')) {
                          exceptionMessage = 'This item already uploaded';
                        }
                        showErrorDialog(context, exceptionMessage);
                      } catch (e) {
                        showErrorDialog(ctx,
                            "Could't upload this. Please try again later.!");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: size.width * 0.3,
                          child: Text(
                            'Upload',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Icon(
                          LineIcons.alternateCloudUpload,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static showConfirmDialog(BuildContext ctx, String title, String contetn,
      List<Widget> actions) async {
    return showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          content: Text(
            contetn,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          actions: actions,
        );
      },
    );
  }

  static void showErrorDialog(BuildContext ctx, String message) {
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).colorScheme.background,
        title: Text('An Error Occurred!',
            style: TextStyle(
              color: Theme.of(ctx).colorScheme.error,
            )),
        content: Text(message, style: Theme.of(ctx).textTheme.titleSmall),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Okay',
              style: Theme.of(ctx).textTheme.titleSmall,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
