import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Sort { titelAsc, titelDesc, createdDateAsc, createdDateDesc, no }

enum NotePreview { grid, list }

enum QuotePreview { list, grid }

class Setting with ChangeNotifier {
  late SharedPreferences prefs;
  late bool _isDarkMode = false;
  String sort = '';
  Sort sortValue = Sort.no;
  NotePreview notePriview = NotePreview.grid;
  QuotePreview quotePreview = QuotePreview.list;

  Setting() {
    loadDarkMode();
    _loadSort();
    _loadNotePreviw();
    _loadQuotePreview();
  }

  // dark mode settings start

  bool get isDarkModeEnabled => _isDarkMode;

  void loadDarkMode() async {
    // loads from sharedPreference
    prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkmode') ?? false;
    notifyListeners();
  }

  void modeToggle() async {
    //toggle and set mode value to shared preference
    prefs = await SharedPreferences.getInstance();
    _isDarkMode = !_isDarkMode;
    prefs.setBool('darkmode', _isDarkMode);
    notifyListeners();
  }
  // dark mode settings end

  // sort settigns start here

  void setSort(Sort s) async {
    // setting sort info
    switch (s) {
      case Sort.titelAsc:
        {
          sort = 'title ASC';
          sortValue = Sort.titelAsc;
        }
        break;
      case Sort.titelDesc:
        {
          sort = 'title DESC';
          sortValue = Sort.titelDesc;
        }
        break;
      case Sort.createdDateAsc:
        {
          sort = 'createdDate ASC';
          sortValue = Sort.createdDateAsc;
        }
        break;
      case Sort.createdDateDesc:
        {
          sort = 'createdDate DESC';
          sortValue = Sort.createdDateDesc;
        }
        break;
      default:
        {
          sort = '';
          sortValue = Sort.no;
        }
    }

    prefs = await SharedPreferences.getInstance();

    prefs.setInt('noteSort', s.index);

    notifyListeners();
  }

  void _loadSort() async {
    //here is loading sort information from shared Preference
    prefs = await SharedPreferences.getInstance();
    final result = prefs.getInt('noteSort') ?? 0;

    switch (result) {
      case 0:
        {
          sortValue = Sort.titelAsc;
          sort = 'title ASC';
        }
        break;
      case 1:
        {
          sortValue = Sort.titelDesc;
          sort = 'title DESC';
        }
        break;
      case 2:
        {
          sortValue = Sort.createdDateAsc;
          sort = 'createdDate ASC';
        }
        break;
      case 3:
        {
          sortValue = Sort.createdDateDesc;
          sort = 'createdDate DESC';
        }
        break;
      default:
        {
          sortValue = Sort.no;
          sort = '';
        }
    }

    notifyListeners();
  }

  Sort get getSort => sortValue;

  // her the preview will go

  void setNotePreview(NotePreview notePrev) async {
    prefs = await SharedPreferences.getInstance();
    notePriview = notePrev;
    prefs.setInt('notePrev', notePriview.index);
    notifyListeners();
  }

  void _loadNotePreviw() async {
    prefs = await SharedPreferences.getInstance();
    int result = prefs.getInt('notePrev') ?? 0;
    switch (result) {
      case 0:
        notePriview = NotePreview.grid;
        break;
      case 1:
        notePriview = NotePreview.list;
        break;
      default:
        notePriview = NotePreview.grid;
    }

    notifyListeners();
  }

  NotePreview get getNotePreview => notePriview;
  //end note preview

  // qoutew preview satrts
  void setQoutePreview(QuotePreview qoutePrev) async {
    prefs = await SharedPreferences.getInstance();
    quotePreview = qoutePrev;
    prefs.setInt('qoutePev', quotePreview.index);
    notifyListeners();
  }

  void _loadQuotePreview() async {
    prefs = await SharedPreferences.getInstance();
    int result = prefs.getInt('qoutePev') ?? 0;
    switch (result) {
      case 0:
        quotePreview = QuotePreview.grid;
        break;
      case 1:
        quotePreview = QuotePreview.list;
        break;
      default:
        quotePreview = QuotePreview.list;
    }

    notifyListeners();
  }

  QuotePreview get getQuotePreview => quotePreview;
}
