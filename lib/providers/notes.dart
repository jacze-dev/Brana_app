import 'dart:convert';

import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import 'package:http/http.dart' as http;

import './note.dart';
import '../models/http_exception.dart';

class Notes extends ChangeNotifier {
  List<Note> _notes = [];
  var showFavoritesOnly = false;
  var isSearching = false;
  var getquery = '';
  var noreason = '';
  late bool showOnlyUploaded = false;
  late String userId;

  late String _token;
  Notes.proxy(this._token, this.userId, this._notes);
  Notes(this.noreason);

  List<Note> get notes {
    if (showFavoritesOnly) {
      List<Note> favNotes = _notes.where((note) => note.isFav).toList();
      if (isSearching) {
        return favNotes
            .where(
              (note) =>
                  note.title.toLowerCase().contains(
                        getquery.toLowerCase(),
                      ) ||
                  note.note.toLowerCase().contains(
                        getquery.toLowerCase(),
                      ),
            )
            .toList();
      }

      return favNotes;
    }
    if (showOnlyUploaded) {
      final uploaded = _notes.where((note) => note.isUploaded).toList();
      if (showFavoritesOnly) {
        List<Note> favQoute = uploaded.where((note) => note.isFav).toList();
        if (isSearching) {
          return favQoute
              .where((note) =>
                  note.title.toLowerCase().contains(getquery.toLowerCase()) ||
                  note.note.toLowerCase().contains(getquery.toLowerCase()))
              .toList();
        }
        return favQoute;
      }
      return uploaded;
    }
    if (isSearching) {
      List<Note> searNotes = List.from(_notes);

      return searNotes
          .where((note) =>
              note.title.toLowerCase().contains(getquery.toLowerCase()) ||
              note.note.toLowerCase().contains(getquery.toLowerCase()))
          .toList();
    }
    return [..._notes];
  }

  bool get isShowFavOnly {
    return showFavoritesOnly;
  }

  Future<void> addNote(Note note) async {
    _notes.insert(0, note);
    await DatabaseHelper.insert('notes', {
      'id': note.id,
      'title': note.title,
      'note': note.note,
      'createdDate': note.createdDate,
      'updatedDate': note.updatedDate,
      'isFav': note.isFav ? 1 : 0,
      'isPinned': note.isPinned ? 1 : 0,
      'isUploaded': note.isUploaded ? 1 : 0
    });
    notifyListeners();
  }

  Future<void> fetchAndSet(String sort) async {
    var noteList = await DatabaseHelper.getData('notes', sort);

    _notes = noteList
        .map((note) => Note(
              id: note['id'] as String,
              title: note['title'] as String,
              note: note['note'] as String,
              createdDate: note['createdDate'] as String,
              updatedDate: note['updatedDate'] as String,
              isFav: note['isFav'] == 1 ? true : false,
              isPinned: note['isPinned'] == 1 ? true : false,
              isUploaded: note['isUploaded'] == 1 ? true : false,
            ))
        .toList();
    notifyListeners();
  }

  void update(String id, Note newNote) {
    String oldId = id;
    newNote.id = id;
    final note = findById(oldId);
    final index = _notes.indexOf(note);
    _notes.removeWhere((note) => note.id == oldId);
    _notes.insert(index, newNote);
    DatabaseHelper.update(id, 'notes', {
      'id': newNote.id,
      'title': newNote.title,
      'note': newNote.note,
      'createdDate': newNote.createdDate,
      'updatedDate': newNote.updatedDate,
      'isFav': newNote.isFav ? 1 : 0,
      'isPinned': newNote.isPinned ? 1 : 0,
      'isUploaded': newNote.isUploaded ? 1 : 0
    });
    notifyListeners();
  }

  void favoriteToggel(String id) {
    final note = _notes.firstWhere((note) => note.id == id);

    note.isFav = !note.isFav;
    update(id, note);
    notifyListeners();
  }

  void showFavtoggel() {
    showFavoritesOnly = !showFavoritesOnly;
    notifyListeners();
  }

  void showOnlyFav() {
    showFavoritesOnly = true;
    notifyListeners();
  }

  void showUploaded() {
    showOnlyUploaded = true;
    notifyListeners();
  }

  void showAll() {
    showFavoritesOnly = false;
    showOnlyUploaded = false;
    notifyListeners();
  }

  void search(String query) {
    isSearching = true;
    getquery = query;
    notifyListeners();
  }

  Note findById(String id) {
    return _notes.firstWhere((note) => note.id == id);
  }

  late Note deletedNote;
  late int index;

  Future<void> delete(String id) async {
    deletedNote = findById(id);
    index = _notes.indexOf(deletedNote);
    _notes.removeWhere((element) => element.id == id);
    await DatabaseHelper.delete('notes', id);
    notifyListeners();
  }

  void unDelete() {
    _notes.insert(index, deletedNote);
    DatabaseHelper.insert('notes', {
      'id': deletedNote.id,
      'title': deletedNote.title,
      'note': deletedNote.note,
      'createdDate': deletedNote.createdDate,
      'updatedDate': deletedNote.updatedDate,
      'isFav': deletedNote.isFav ? 1 : 0,
      'isPinned': deletedNote.isPinned ? 1 : 0,
      'isUploaded': deletedNote.isUploaded ? 1 : 0
    });

    notifyListeners();
  }

  void removeFromFav(String id) {
    final note = _notes.firstWhere((note) => note.id == id);

    note.isFav = !note.isFav;
    update(id, note);
    notifyListeners();
  }

  void pinToggel(String id) {
    final note = findById(id);
    final index = _notes.indexOf(note);
    note.isPinned = !note.isPinned;
    if (note.isPinned) {
      _notes.insert(0, note);
      _notes.removeAt(index + 1);
    }
    notifyListeners();
  }

  Future<void> uploadOneNote(String id) async {
    final note = findById(id);
    if (note.isUploaded) {
      throw HttpException('ITEM_EXISTS');
    }
    final url =
        'https://brana-note-aaa69-default-rtdb.europe-west1.firebasedatabase.app/notes/$userId.json?auth=$_token';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': note.title,
            'note': note.note,
            'createdDate': note.createdDate,
            'updatedDate': note.updatedDate,
            'isFav': note.isFav,
            'isPinned': note.isPinned,
            'isUploaded': true
          }));
      final responseNote = json.decode(response.body);
      if (responseNote['error'] != null) {
        throw HttpException(responseNote['error']['message']);
      }
      update(
        id,
        Note(
          id: responseNote['name'],
          title: note.title,
          note: note.note,
          createdDate: note.createdDate,
          updatedDate: note.updatedDate,
          isPinned: note.isPinned,
          isFav: note.isFav,
          isUploaded: true,
        ),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadAll(List<Note> notes) async {
    for (Note n in notes) {
      if (!n.isUploaded) {
        await uploadOneNote(n.id);
      }
    }
  }

  Future<void> fetchAndSetFromServer() async {
    final url =
        'https://brana-note-aaa69-default-rtdb.europe-west1.firebasedatabase.app/notes/$userId.json?auth=$_token';

    final response = await http.get(Uri.parse(url));
    final loadedNotes = json.decode(response.body) as Map<String, dynamic>;
    if (loadedNotes != {}) {
      loadedNotes.forEach((noteId, note) {
        final condition = notes.firstWhere(
          (element) => element.id == noteId,
          orElse: () => Note(
              id: '000000',
              title: 'title',
              note: 'note',
              createdDate: 'createdDate',
              updatedDate: 'updatedDate',
              isPinned: false,
              isFav: false,
              isUploaded: false),
        );

        if (condition.id != noteId) {
          addNote(
            Note(
              id: noteId,
              title: note['title'],
              note: note['note'],
              createdDate: note['createdDate'],
              updatedDate: note['updatedDate'],
              isPinned: note['isPinned'],
              isFav: note['isFav'],
              isUploaded: true,
            ),
          );
        }
      });
      notifyListeners();
    }
  }
}
