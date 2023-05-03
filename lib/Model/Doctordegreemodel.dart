/// message : "Degree retrieved successfully"
/// error : false
/// data : [{"id":"1","name":"MBBS","created_at":"2023-04-17 19:25:00"},{"id":"2","name":"BHMS","created_at":"2023-04-17 19:25:06"}]

class Doctordegreemodel {
  Doctordegreemodel({
      String? message,
      bool? error,
      List<DoctorList>? data,}){
    _message = message;
    _error = error;
    _data = data;
}

  Doctordegreemodel.fromJson(dynamic json) {
    _message = json['message'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DoctorList.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _error;
  List<DoctorList>? _data;
Doctordegreemodel copyWith({  String? message,
  bool? error,
  List<DoctorList>? data,
}) => Doctordegreemodel(  message: message ?? _message,
  error: error ?? _error,
  data: data ?? _data,
);
  String? get message => _message;
  bool? get error => _error;
  List<DoctorList>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1"
/// name : "MBBS"
/// created_at : "2023-04-17 19:25:00"

class DoctorList {
  DoctorList({
      String? id,
      String? name,
      String? createdAt,}){
    _id = id;
    _name = name;
    _createdAt = createdAt;
}

  DoctorList.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _createdAt = json['created_at'];
  }
  String? _id;
  String? _name;
  String? _createdAt;
DoctorList copyWith({  String? id,
  String? name,
  String? createdAt,
}) => DoctorList(  id: id ?? _id,
  name: name ?? _name,
  createdAt: createdAt ?? _createdAt,
);
  String? get id => _id;
  String? get name => _name;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['created_at'] = _createdAt;
    return map;
  }

}