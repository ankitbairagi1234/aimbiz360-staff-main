/// message : "Specialization retrieved successfully"
/// error : false
/// data : [{"id":"1","name":"Orthopedics","created_at":"2023-04-17 19:48:57"},{"id":"2","name":"Internal Medicine","created_at":"2023-04-17 19:49:05"}]

class Spesilizationmodel {
  Spesilizationmodel({
      String? message, 
      bool? error, 
      List<Drspesilization>? data,}){
    _message = message;
    _error = error;
    _data = data;
}

  Spesilizationmodel.fromJson(dynamic json) {
    _message = json['message'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Drspesilization.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _error;
  List<Drspesilization>? _data;
Spesilizationmodel copyWith({  String? message,
  bool? error,
  List<Drspesilization>? data,
}) => Spesilizationmodel(  message: message ?? _message,
  error: error ?? _error,
  data: data ?? _data,
);
  String? get message => _message;
  bool? get error => _error;
  List<Drspesilization>? get data => _data;

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
/// name : "Orthopedics"
/// created_at : "2023-04-17 19:48:57"

class Drspesilization {
  Drspesilization({
      String? id, 
      String? name, 
      String? createdAt,}){
    _id = id;
    _name = name;
    _createdAt = createdAt;
}

  Drspesilization.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _createdAt = json['created_at'];
  }
  String? _id;
  String? _name;
  String? _createdAt;
Drspesilization copyWith({  String? id,
  String? name,
  String? createdAt,
}) => Drspesilization(  id: id ?? _id,
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