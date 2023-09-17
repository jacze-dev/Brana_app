// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/qoute.dart';
import '../providers/note.dart';
import '../providers/notes.dart';
import '../providers/qoutes.dart';

enum Type { note, qoute }

class EditNewScreen extends StatefulWidget {
  static String routeName = '/edit_new_Screen';

  const EditNewScreen({super.key});

  @override
  State<EditNewScreen> createState() => _EditNewScreenState();
}

class _EditNewScreenState extends State<EditNewScreen> {
  bool isNote = false;
  String id = '';
  bool readMode = false;
  var noteInitialValue = {
    'id': '',
    'title': '',
    'note': '',
    'createdDate': '',
    'updatedDate': '',
    'isFav': false,
    'isUploaded': false
  };
  var qouteInitialValue = {
    'id': '',
    'title': '',
    'qoute': '',
    'qoutedBy': '',
    'isFav': false,
    'isUploaded': false
  };
  var _editedNote = Note(
    id: DateTime.now().toString(),
    title: '',
    note: '',
    createdDate: DateTime.now().toString(),
    updatedDate: DateTime.now().toString(),
    isPinned: false,
    isFav: false,
    isUploaded: false,
  );

  var _editedQoute = Qoute(
    id: DateTime.now().toString(),
    title: '',
    qoute: '',
    qoutedBy: '',
    createdDate: DateTime.now().toString(),
    updatedDate: DateTime.now().toString(),
    isFav: false,
    isPinned: false,
    isUploaded: false,
  );
  @override
  void didChangeDependencies() {
    final result =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    isNote = result['isNote']! as bool;
    id = result['id']! as String;
    if (isNote) {
      if (id != '') {
        _editedNote = Provider.of<Notes>(context, listen: false).findById(id);
        noteInitialValue = {
          'id': _editedNote.id,
          'title': _editedNote.title,
          'note': _editedNote.note,
          'createdDate': _editedNote.createdDate,
          'updatedDate': DateTime.now().toString(),
          'isPinned': _editedNote.isPinned,
          'isFav': _editedNote.isFav,
          'isUploaded': _editedNote.isUploaded
        };
      }
    } else {
      if (id != '') {
        _editedQoute = Provider.of<Qoutes>(context, listen: false).findById(id);

        qouteInitialValue = {
          'id': _editedQoute.id,
          'title': _editedQoute.title,
          'qoute': _editedQoute.qoute,
          'qoutedBy': _editedQoute.qoutedBy,
          'createdDate': _editedQoute.createdDate,
          'updatedDate': DateTime.now().toString(),
          'isFav': _editedQoute.isFav,
          'isPinned': _editedQoute.isPinned,
          'isUploaded': _editedQoute.isUploaded,
        };
      }
    }
    super.didChangeDependencies();
  }

  final _form = GlobalKey<FormState>();

  void _save() {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    if (isNote) {
      if (_editedNote.note != '') {
        if (_editedNote.title == '') _editedNote.title = 'No Title';
        if (id == '') {
          Provider.of<Notes>(context, listen: false).addNote(_editedNote);
        } else {
          Provider.of<Notes>(context, listen: false).update(id, _editedNote);
        }
      }
    } else {
      if (_editedQoute.qoute != '') {
        if (_editedQoute.title == '') _editedQoute.title = 'No Title';
        if (_editedQoute.qoutedBy == '') _editedQoute.qoutedBy = 'Unkown';
        if (id == '') {
          Provider.of<Qoutes>(context, listen: false).addQoute(_editedQoute);
        } else {
          Provider.of<Qoutes>(context, listen: false)
              .updateQoute(id, _editedQoute);
        }
      }
    }
  }

  void _readOnly() {
    setState(() {
      readMode = !readMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      _save();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isNote
                                ? {
                                    _editedNote.isFav = !_editedNote.isFav,
                                  }
                                : {
                                    _editedQoute.isFav = !_editedQoute.isFav,
                                  };
                          });
                        },
                        icon: Icon(
                          isNote
                              ? _editedNote.isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border
                              : _editedQoute.isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                        ),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      IconButton(
                        onPressed: () {
                          _readOnly();
                        },
                        icon: Icon(readMode
                            ? Icons.chrome_reader_mode
                            : Icons.chrome_reader_mode_outlined),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  children: [
                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              initialValue: isNote
                                  ? noteInitialValue['title'].toString()
                                  : qouteInitialValue['title'].toString(),
                              style: Theme.of(context).textTheme.titleMedium,
                              onSaved: (newValue) {
                                isNote
                                    ? _editedNote = Note(
                                        id: _editedNote.id,
                                        title: newValue!,
                                        note: _editedNote.note,
                                        createdDate: _editedNote.createdDate,
                                        updatedDate: _editedNote.updatedDate,
                                        isPinned: _editedNote.isPinned,
                                        isFav: _editedNote.isFav,
                                        isUploaded: _editedNote.isUploaded,
                                      )
                                    : _editedQoute = Qoute(
                                        id: DateTime.now().toString(),
                                        title: newValue!,
                                        qoute: _editedQoute.qoute,
                                        qoutedBy: _editedQoute.qoutedBy,
                                        createdDate: _editedQoute.createdDate,
                                        updatedDate: _editedQoute.updatedDate,
                                        isFav: _editedQoute.isFav,
                                        isPinned: _editedQoute.isPinned,
                                        isUploaded: _editedQoute.isUploaded,
                                      );
                              },
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Title',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              readOnly: readMode,
                            ),
                          ),
                          Divider(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03),
                            child: TextFormField(
                              initialValue: isNote
                                  ? noteInitialValue['note'].toString()
                                  : qouteInitialValue['qoute'].toString(),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              onSaved: (newValue) {
                                isNote
                                    ? _editedNote = Note(
                                        id: _editedNote.id,
                                        title: _editedNote.title,
                                        note: newValue!,
                                        createdDate: _editedNote.createdDate,
                                        updatedDate: _editedNote.updatedDate,
                                        isPinned: _editedNote.isPinned,
                                        isFav: _editedNote.isFav,
                                        isUploaded: _editedNote.isUploaded,
                                      )
                                    : _editedQoute = Qoute(
                                        id: DateTime.now().toString(),
                                        title: _editedQoute.title,
                                        qoute: newValue!,
                                        qoutedBy: _editedQoute.qoutedBy,
                                        createdDate: _editedQoute.createdDate,
                                        updatedDate: _editedQoute.updatedDate,
                                        isFav: _editedQoute.isFav,
                                        isPinned: _editedQoute.isPinned,
                                        isUploaded: _editedQoute.isUploaded,
                                      );
                              },
                              readOnly: readMode,
                              maxLines: isNote ? 1000 : 10,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: isNote
                                    ? 'Type note here ...'
                                    : 'Type the qoute here ...',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          if (!isNote)
                            Divider(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03),
                            child: TextFormField(
                              initialValue:
                                  qouteInitialValue['qoutedBy'].toString(),
                              onSaved: (newValue) {
                                _editedQoute = Qoute(
                                  id: DateTime.now().toString(),
                                  title: _editedQoute.title,
                                  qoute: _editedQoute.qoute,
                                  qoutedBy: newValue!,
                                  createdDate: _editedQoute.createdDate,
                                  updatedDate: _editedQoute.updatedDate,
                                  isFav: _editedQoute.isFav,
                                  isPinned: _editedQoute.isPinned,
                                  isUploaded: _editedQoute.isUploaded,
                                );
                              },
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Qouted by...',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                              readOnly: readMode,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
