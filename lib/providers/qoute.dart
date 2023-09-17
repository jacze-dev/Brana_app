class Qoute {
  String id;
  String title;
  String qoute;
  String qoutedBy;
  String createdDate;
  String updatedDate;
  bool isFav;
  bool isPinned;
  bool isUploaded;
  Qoute({
    required this.id,
    required this.title,
    required this.qoute,
    required this.qoutedBy,
    required this.createdDate,
    required this.updatedDate,
    required this.isFav,
    required this.isPinned,
    required this.isUploaded,
  });
}
