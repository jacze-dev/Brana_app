import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/qoutes.dart';

import '../providers/note.dart';
import '../providers/notes.dart';
import '../providers/qoute.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/detailSecreen';
  final String id;
  final bool isNote;
  const DetailScreen({super.key, required this.id, required this.isNote});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Note note;
  late Qoute qoute;
  @override
  void didChangeDependencies() {
    widget.isNote
        ? note = Provider.of<Notes>(context, listen: false).findById(widget.id)
        : qoute =
            Provider.of<Qoutes>(context, listen: false).findById(widget.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.surface,
              )),
          title: Text(
            'Detail Information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: SizedBox(
          height: size.height * 0.4,
          child: Column(
            children: [
              ListTile(
                leading: Text(
                  'Title',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: Text(
                  widget.isNote ? note.title : qoute.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                leading: Text(
                  'Type',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: Text(
                  widget.isNote ? 'Note' : 'Quote',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                leading: Text(
                  'Created date',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: Text(
                  widget.isNote
                      ? DateFormat.yMMMd()
                          .format(DateTime.parse(note.createdDate))
                      : DateFormat.yMMMd()
                          .format(DateTime.parse(qoute.createdDate)),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                leading: Text(
                  'Size',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: Text(
                  widget.isNote
                      ? "${((note.title.length + note.note.length))}  Bytes"
                      : "${((qoute.title.length + qoute.qoute.length))}  Bytes",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                leading: Text(
                  'Upload Status',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: Text(
                  widget.isNote
                      ? note.isUploaded
                          ? 'Uploaded'
                          : 'Not uploaded'
                      : qoute.isUploaded
                          ? 'Uploaded'
                          : 'Not uploaded',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                leading: Text(
                  'Favorite Status',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: Text(
                  widget.isNote
                      ? note.isFav
                          ? 'Favorited'
                          : 'Not favorited'
                      : qoute.isFav
                          ? 'Favorited'
                          : 'Not favorited',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ));
  }
}
