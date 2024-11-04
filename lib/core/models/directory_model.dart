class DirectoryModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? name;
  int? size;
  String? parentID;
  String? ownerID;
  String? directoryID;
  List<Privilege>? privileges;
  List<DirectoryModel>? subDirectories;
  List<DirectoryModel>? files;
  String? mimeType;
  bool? favorite;
  List<String>? sharedWith;

  DirectoryModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.name,
    this.size,
    this.parentID,
    this.privileges,
    this.subDirectories,
    this.files,
    this.mimeType,
    this.favorite,
    this.sharedWith,
    this.directoryID,
    this.ownerID,
  });

  DirectoryModel.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    name = json['name'];
    size = json['size'].toInt();
    parentID = json['parentId'];
    ownerID = json['ownerId'];
    directoryID = json['directoryId'];
    favorite = json['favorite'];
    mimeType = json['mimeType'];
    if (json['sharedWith'] != null) {
      sharedWith = json['sharedWith'].cast<String>();
    }
    if (json['privileges'] != null) {
      privileges = <Privilege>[];
      json['privileges'].forEach((v) {
        privileges!.add(Privilege.fromJson(v));
      });
    }
    if (json['subDirectories'] != null) {
      subDirectories = <DirectoryModel>[];
      json['subDirectories'].forEach((v) {
        subDirectories!.add(DirectoryModel.fromJson(v));
      });
    }
    if (json['files'] != null) {
      files = <DirectoryModel>[];
      json['files'].forEach((v) {
        files!.add(DirectoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['name'] = name;
    data['size'] = size;
    data['parentId'] = parentID;
    data['sharedWith'] = sharedWith;
    data['ownerId'] = ownerID;
    data['directoryId'] = directoryID;
    data['favorite'] = favorite;
    data['mimeType'] = mimeType;
    if (privileges != null) {
      data['privileges'] = privileges!.map((v) => v.toJson()).toList();
    }
    if (subDirectories != null) {
      data['subDirectories'] = subDirectories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Privilege {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? decryptionKey;
  bool? read;
  bool? write;
  bool? owner;

  Privilege({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.decryptionKey,
    this.read,
    this.write,
    this.owner,
  });

  Privilege.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    decryptionKey = json['decryptionKey'];
    read = json['read'];
    write = json['write'];
    owner = json['owner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['decryptionKey'] = decryptionKey;
    data['read'] = read;
    data['write'] = write;
    data['owner'] = owner;
    return data;
  }
}

class KeyAndId {
  String? id;
  String? key;

  KeyAndId({
    this.id,
    this.key,
  });

  KeyAndId.fromJson(dynamic json) {
    id = json.keys.first;
    key = json.values.first;
  }
}
