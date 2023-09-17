// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../helpers/dialog_helper.dart';
import '../models/http_exception.dart';
import '../providers/qoutes.dart';
import '../providers/setting.dart';
import '../screens/edit_new_screen.dart';

// ignore: must_be_immutable
class QouteCard extends StatelessWidget {
  bool isInNote = false;
  String id;
  String title;
  String qoute;
  String qoutedBy;
  String createdDate;
  String updatedDate;
  bool isFav;
  bool isPinned;
  bool isUploaded;
  Function fun;
  QouteCard({
    super.key,
    required this.id,
    required this.title,
    required this.qoute,
    required this.qoutedBy,
    required this.createdDate,
    required this.updatedDate,
    required this.isFav,
    required this.isPinned,
    required this.isUploaded,
    required this.fun,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.27,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(EditNewScreen.routeName,
              arguments: {'isNote': false, 'id': id});
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(size.height * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: Provider.of<Setting>(context).getQuotePreview ==
                                QuotePreview.grid
                            ? size.width * 0.25
                            : size.width * 0.7,
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                        child: IconButton(
                          onPressed: () async {
                            try {
                              await Provider.of<Qoutes>(context, listen: false)
                                  .quoteOneUpload(id);

                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  child: Text(
                    qoute,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textWidthBasis: TextWidthBasis.longestLine,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          Provider.of<Qoutes>(context, listen: false)
                              .favoriteToggel(id);
                        },
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Theme.of(context).colorScheme.surface,
                        )),
                    SizedBox(
                      width: Provider.of<Setting>(context).getQuotePreview ==
                              QuotePreview.grid
                          ? size.width * 0.3
                          : size.width * 0.7,
                      child: Text(
                        qoutedBy,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
