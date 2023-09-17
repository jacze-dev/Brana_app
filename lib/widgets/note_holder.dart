import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/setting.dart';
import './notecard.dart';
import '../helpers/dialog_helper.dart';
import '../providers/notes.dart';

class NoteHolder extends StatefulWidget {
  const NoteHolder({super.key});

  @override
  State<NoteHolder> createState() => _NoteHolderState();
}

class _NoteHolderState extends State<NoteHolder> {
  late Future<void> fetchNote;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: Provider.of<Notes>(context, listen: false)
            .fetchAndSet(Provider.of<Setting>(context).sort),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Consumer<Notes>(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'asset/svg/empty_wallet.svg',
                        // ignore: deprecated_member_use
                        color: Theme.of(context).colorScheme.secondary,
                        height: size.height * 0.1,
                      ),
                      const Text('Got no notes yet, start adding some!'),
                    ],
                  ),
                ),
                builder: (context, note, ch) {
                  return note.notes.isEmpty
                      ? ch!
                      : Provider.of<Setting>(context).getNotePreview ==
                              NotePreview.list
                          ? ListView.builder(
                              padding: EdgeInsets.all(size.width * 0.03),
                              itemBuilder: (context, index) {
                                return NoteCard(
                                  id: note.notes[index].id,
                                  title: Provider.of<Notes>(context)
                                      .notes[index]
                                      .title,
                                  note: note.notes[index].note,
                                  createdDate: note.notes[index].createdDate,
                                  updatedDate: note.notes[index].updatedDate,
                                  isFav: note.notes[index].isFav,
                                  isPinned: note.notes[index].isPinned,
                                  isUploaded: note.notes[index].isUploaded,
                                  fun: DialogHelper.showOptionDialog,
                                );
                              },
                              itemCount: note.notes.length,
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: size.height * 0.3),
                              itemCount: note.notes.length,
                              padding: EdgeInsets.all(size.width * 0.03),
                              itemBuilder: (BuildContext context, int index) {
                                return NoteCard(
                                  id: note.notes[index].id,
                                  title: Provider.of<Notes>(context)
                                      .notes[index]
                                      .title,
                                  note: note.notes[index].note,
                                  createdDate: note.notes[index].createdDate,
                                  updatedDate: note.notes[index].updatedDate,
                                  isFav: note.notes[index].isFav,
                                  isPinned: note.notes[index].isPinned,
                                  isUploaded: note.notes[index].isUploaded,
                                  fun: DialogHelper.showOptionDialog,
                                );
                              },
                            );
                });
          }
        });
  }
}
