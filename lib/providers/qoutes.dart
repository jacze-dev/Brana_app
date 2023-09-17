import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/db_helper.dart';
import '../models/http_exception.dart';
import './qoute.dart';

class Qoutes extends ChangeNotifier {
  List<Qoute> _qoutes = [];
  var showOnlyFavorite = false;
  var isSearching = false;
  late String fetchquery;
  late bool showOnlyUploaded = false;
  late String _userId;

  late String _token;
  Qoutes.proxy(this._qoutes, this._userId, this._token);
  Qoutes();

  List<Qoute> get qoutes {
    if (showOnlyFavorite) {
      List<Qoute> favQoute = _qoutes.where((qoute) => qoute.isFav).toList();
      if (isSearching) {
        return favQoute
            .where((qoute) =>
                qoute.title.toLowerCase().contains(fetchquery.toLowerCase()) ||
                qoute.qoute.toLowerCase().contains(fetchquery.toLowerCase()) ||
                qoute.qoutedBy.toLowerCase().contains(fetchquery.toLowerCase()))
            .toList();
      }
      return favQoute;
    }
    if (showOnlyUploaded) {
      final uploaded = _qoutes.where((qoute) => qoute.isUploaded).toList();
      if (showOnlyFavorite) {
        List<Qoute> favQoute = uploaded.where((qoute) => qoute.isFav).toList();
        if (isSearching) {
          return favQoute
              .where((qoute) =>
                  qoute.title
                      .toLowerCase()
                      .contains(fetchquery.toLowerCase()) ||
                  qoute.qoute
                      .toLowerCase()
                      .contains(fetchquery.toLowerCase()) ||
                  qoute.qoutedBy
                      .toLowerCase()
                      .contains(fetchquery.toLowerCase()))
              .toList();
        }
        return favQoute;
      }
      return uploaded;
    }
    if (isSearching) {
      List<Qoute> searQoute = List.from(_qoutes);
      return searQoute
          .where((qoute) =>
              qoute.title.toLowerCase().contains(fetchquery.toLowerCase()) ||
              qoute.qoute.toLowerCase().contains(fetchquery.toLowerCase()) ||
              qoute.qoutedBy.toLowerCase().contains(fetchquery.toLowerCase()))
          .toList();
    }

    return [..._qoutes];
  }

  String get userId {
    return _userId;
  }

  Future<void> addQoute(Qoute qoute) async {
    _qoutes.insert(0, qoute);
    await DatabaseHelper.insert('quotes', {
      'id': qoute.id,
      'title': qoute.title,
      'qoute': qoute.qoute,
      'qoutedBy': qoute.qoutedBy,
      'createdDate': qoute.createdDate,
      'updatedDate': qoute.updatedDate,
      'isFav': qoute.isFav ? 1 : 0,
      'isPinned': qoute.isPinned ? 1 : 0,
      'isUploaded': qoute.isUploaded ? 1 : 0,
    });
    notifyListeners();
  }

  Future<void> fetchAndSet(String sort) async {
    final qouteList = await DatabaseHelper.getData('quotes', sort);

    _qoutes = qouteList
        .map(
          (qoute) => Qoute(
              id: qoute['id'] as String,
              title: qoute['title'] as String,
              qoute: qoute['qoute'] as String,
              qoutedBy: qoute['qoutedBy'] as String,
              createdDate: qoute['createdDate'] as String,
              updatedDate: qoute['updatedDate'] as String,
              isFav: qoute['isFav'] == 1 ? true : false,
              isPinned: qoute['isPinned'] == 1 ? true : false,
              isUploaded: qoute['isUploaded'] == 1 ? true : false),
        )
        .toList();
    notifyListeners();
  }

  Future<void> updateQoute(String id, Qoute newQoute) async {
    final oldId = id;
    final oldQoute = findById(id);
    final index = _qoutes.indexOf(oldQoute);
    _qoutes.removeWhere((qoute) => qoute.id == oldId);
    _qoutes.insert(index, newQoute);
    await DatabaseHelper.update(id, 'quotes', {
      'id': newQoute.id,
      'title': newQoute.title,
      'qoute': newQoute.qoute,
      'qoutedBy': newQoute.qoutedBy,
      'createdDate': newQoute.createdDate,
      'updatedDate': newQoute.updatedDate,
      'isFav': newQoute.isFav ? 1 : 0,
      'isPinned': newQoute.isPinned ? 1 : 0,
      'isUploaded': newQoute.isUploaded ? 1 : 0
    });
    notifyListeners();
  }

  bool get isShowFavOnly {
    return showOnlyFavorite;
  }

  void favoriteToggel(String id) {
    final qoute = _qoutes.firstWhere((qoute) => qoute.id == id);
    qoute.isFav = !qoute.isFav;
    updateQoute(id, qoute);
    notifyListeners();
  }

  void showFavToggel() {
    showOnlyFavorite = !showOnlyFavorite;
    notifyListeners();
  }

  void showOnlyFav() {
    showOnlyFavorite = true;
    notifyListeners();
  }

  void showUploaded() {
    showOnlyUploaded = true;
    notifyListeners();
  }

  void showAll() {
    showOnlyFavorite = false;
    showOnlyUploaded = false;
    notifyListeners();
  }

  void search(String query) {
    isSearching = true;
    fetchquery = query;
  }

  Qoute findById(String id) {
    return _qoutes.firstWhere((qoute) => qoute.id == id);
  }

  late Qoute deletedQoute;
  late int index;
  void delete(String id) {
    deletedQoute = findById(id);
    index = _qoutes.indexOf(deletedQoute);
    _qoutes.removeWhere((element) => element.id == id);
    DatabaseHelper.delete('quotes', id);
    notifyListeners();
  }

  Future<void> unDelete() async {
    _qoutes.insert(index, deletedQoute);
    await DatabaseHelper.insert('quotes', {
      'id': deletedQoute.id,
      'title': deletedQoute.title,
      'qoute': deletedQoute.qoute,
      'qoutedBy': deletedQoute.qoutedBy,
      'createdDate': deletedQoute.createdDate,
      'updatedDate': deletedQoute.updatedDate,
      'isFav': deletedQoute.isFav ? 1 : 0,
      'isPinned': deletedQoute.isPinned ? 1 : 0,
      'isUploaded': deletedQoute.isUploaded ? 1 : 0
    });
    notifyListeners();
  }

  void qoutePin(String id) {
    final qoute = findById(id);
    final index = _qoutes.indexOf(qoute);
    _qoutes.insert(0, qoute);
    _qoutes.removeAt(index + 1);
    notifyListeners();
  }

  Future<void> quoteOneUpload(String id) async {
    final quote = findById(id);

    if (quote.isUploaded) {
      throw HttpException('ITEM_EXISTS');
    }
    final url =
        'https://brana-note-aaa69-default-rtdb.europe-west1.firebasedatabase.app/quotes/$userId.json?auth=$_token';

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': quote.title,
            'qoute': quote.qoute,
            'qoutedBy': quote.qoutedBy,
            'createdDate': quote.createdDate,
            'updatedDate': quote.updatedDate,
            'isFav': quote.isFav,
            'isPinned': quote.isPinned,
            'isUploaded': true
          }));
      final responseQoute = json.decode(response.body);
      if (responseQoute['error'] != null) {
        throw HttpException(responseQoute['error']['message']);
      }

      updateQoute(
        id,
        Qoute(
          id: responseQoute['name'],
          title: quote.title,
          qoute: quote.qoute,
          qoutedBy: quote.qoutedBy,
          createdDate: quote.createdDate,
          updatedDate: quote.updatedDate,
          isFav: quote.isFav,
          isPinned: quote.isPinned,
          isUploaded: true,
        ),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadAll(List<Qoute> quotes) async {
    for (Qoute q in qoutes) {
      if (!q.isUploaded) {
        await quoteOneUpload(q.id);
      }
    }
  }

  Future<void> fetchAndSetFromServer() async {
    final url =
        'https://brana-note-aaa69-default-rtdb.europe-west1.firebasedatabase.app/quotes/$userId.json?auth=$_token';

    final response = await http.get(Uri.parse(url));
    final loadedQuotes = json.decode(response.body) as Map<String, dynamic>;
    if (loadedQuotes != {}) {
      loadedQuotes.forEach((quoteId, qoute) {
        final condition = qoutes.firstWhere(
          (element) => element.id == quoteId,
          orElse: () => Qoute(
              id: '00000',
              title: 'title',
              qoute: 'qoute',
              qoutedBy: 'qoutedBy',
              createdDate: 'createdDate',
              updatedDate: 'updatedDate',
              isFav: false,
              isPinned: false,
              isUploaded: false),
        );
        if (condition.id != quoteId) {
          addQoute(
            Qoute(
              id: quoteId,
              title: qoute['title'],
              qoute: qoute['qoute'],
              qoutedBy: qoute['qoutedBy'],
              createdDate: qoute['createdDate'],
              updatedDate: qoute['updatedDate'],
              isPinned: qoute['isPinned'],
              isFav: qoute['isFav'],
              isUploaded: qoute['isUploaded'],
            ),
          );
        }

        notifyListeners();
      });
    }
  }
}
