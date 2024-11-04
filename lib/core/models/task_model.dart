class ZTask {
  String? message;
  ZTaskType? type;
  int? progress;
  int? total;
  String? id;

  ZTask({
    this.id,
    this.type,
    this.progress,
    this.total,
    this.message,
  });
}

enum ZTaskType { CREATE_FILE, UPLOAD_CHUNK }
