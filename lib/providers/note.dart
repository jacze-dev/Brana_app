class Note {
  String id;
  String title;
  String note;
  String createdDate;
  String updatedDate;
  bool isPinned;
  bool isFav;
  bool isUploaded;

  Note(
      {required this.id,
      required this.title,
      required this.note,
      required this.createdDate,
      required this.updatedDate,
      required this.isPinned,
      required this.isFav,
      required this.isUploaded});
}
