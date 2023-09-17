// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';
import '../helpers/dialog_helper.dart';

import '../models/http_exception.dart';
import '../screens/edit_new_screen.dart';
import '../providers/notes.dart';

class NoteCard extends StatelessWidget {
  bool isInNote = true;
  final String id;
  final String title;
  final String note;
  final String createdDate;
  final String updatedDate;
  final bool isFav;
  final bool isPinned;
  final bool isUploaded;
  final Function fun;
  NoteCard(
      {super.key,
      required this.id,
      required this.title,
      required this.note,
      required this.createdDate,
      required this.updatedDate,
      required this.isFav,
      required this.isPinned,
      required this.isUploaded,
      required this.fun});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(EditNewScreen.routeName,
            arguments: {'isNote': true, 'id': id});
      },
      onLongPress: () {
        fun(isInNote, context, id);
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.onBackground,
                blurRadius: size.width * 0.007,
                spreadRadius: 0)
          ],
          borderRadius: BorderRadius.circular(size.width * 0.05),
        ),
        child: Card(
          elevation: 5,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: size.width * 0.4,
                    // width: double.infinity,
                    padding: EdgeInsets.all(size.height * 0.02),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Container(
                height: size.height * 0.07,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.03),
                child: Text(
                  note,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () async {
                        try {
                          await Provider.of<Notes>(context, listen: false)
                              .uploadOneNote(id);

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('uploaded succesfuly!')));
                        } on HttpException catch (error) {
                          var exceptionMessage = 'unable to upload';
                          if (error.toString().contains('ITEM_EXISTS')) {
                            exceptionMessage = 'This item already uploaded';
                          }

                          DialogHelper.showErrorDialog(
                              context, exceptionMessage);
                        } catch (e) {
                          DialogHelper.showErrorDialog(context,
                              "Could't upload this. Please try again later.!");
                        }
                      },
                      icon: Icon(
                        isUploaded
                            ? LineIcons.cloud
                            : LineIcons.alternateCloudUpload,
                        color: Theme.of(context).colorScheme.surface,
                      )),
                  IconButton(
                    onPressed: () {
                      Provider.of<Notes>(context, listen: false)
                          .favoriteToggel(id);
                    },
                    icon: Icon(
                      !isFav ? Icons.favorite_border : Icons.favorite,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
