/// error : false
/// message : "Data Succesfully Show"
/// data : [{"id":"5","user_id":"219","name":"Shivani","mobile":"9696323214","share_info":"1","category_id":"7","assign_to":"220","remark":"this lead is finally closed ","status":"Closed","created_at":"2023-04-26 11:37:35","update_at":"2023-04-26 11:32:52","product":"SBI Credit Card","reffer_to":"Shivani","reffer_from":"Karan"},{"id":"2","user_id":"234","name":"Sawan","mobile":"9999922255","share_info":"0","category_id":"3","assign_to":"220","remark":"this is final test and check closed lead ","status":"Closed","created_at":"2023-04-25 20:26:04","update_at":"2023-04-25 20:23:09","product":"Home Loan & LAP","reffer_to":"Sawan","reffer_from":"Harish"},{"id":"1","user_id":"234","name":"Karan","mobile":"8770496665","share_info":"1","category_id":"8","assign_to":"220","remark":"this is new test remark","status":"Closed","created_at":"2023-04-25 20:21:02","update_at":"2023-04-25 20:18:33","product":"HDFC Credit Card","reffer_to":"Karan","reffer_from":"Harish"}]

class MyLeadsModel {
  MyLeadsModel({
      bool? error, 
      String? message, 
      List<MyLeads>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  MyLeadsModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(MyLeads.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<MyLeads>? _data;
MyLeadsModel copyWith({  bool? error,
  String? message,
  List<MyLeads>? data,
}) => MyLeadsModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  List<MyLeads>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "5"
/// user_id : "219"
/// name : "Shivani"
/// mobile : "9696323214"
/// share_info : "1"
/// category_id : "7"
/// assign_to : "220"
/// remark : "this lead is finally closed "
/// status : "Closed"
/// created_at : "2023-04-26 11:37:35"
/// update_at : "2023-04-26 11:32:52"
/// product : "SBI Credit Card"
/// reffer_to : "Shivani"
/// reffer_from : "Karan"

class MyLeads {
  MyLeads({
      String? id, 
      String? userId, 
      String? name, 
      String? mobile, 
      String? shareInfo, 
      String? categoryId, 
      String? assignTo, 
      String? remark, 
      String? status, 
      String? createdAt, 
      String? updateAt, 
      String? product, 
      String? refferTo, 
      String? refferFrom,}){
    _id = id;
    _userId = userId;
    _name = name;
    _mobile = mobile;
    _shareInfo = shareInfo;
    _categoryId = categoryId;
    _assignTo = assignTo;
    _remark = remark;
    _status = status;
    _createdAt = createdAt;
    _updateAt = updateAt;
    _product = product;
    _refferTo = refferTo;
    _refferFrom = refferFrom;
}

  MyLeads.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _name = json['name'];
    _mobile = json['mobile'];
    _shareInfo = json['share_info'];
    _categoryId = json['category_id'];
    _assignTo = json['assign_to'];
    _remark = json['remark'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updateAt = json['update_at'];
    _product = json['product'];
    _refferTo = json['reffer_to'];
    _refferFrom = json['reffer_from'];
  }
  String? _id;
  String? _userId;
  String? _name;
  String? _mobile;
  String? _shareInfo;
  String? _categoryId;
  String? _assignTo;
  String? _remark;
  String? _status;
  String? _createdAt;
  String? _updateAt;
  String? _product;
  String? _refferTo;
  String? _refferFrom;
MyLeads copyWith({  String? id,
  String? userId,
  String? name,
  String? mobile,
  String? shareInfo,
  String? categoryId,
  String? assignTo,
  String? remark,
  String? status,
  String? createdAt,
  String? updateAt,
  String? product,
  String? refferTo,
  String? refferFrom,
}) => MyLeads(  id: id ?? _id,
  userId: userId ?? _userId,
  name: name ?? _name,
  mobile: mobile ?? _mobile,
  shareInfo: shareInfo ?? _shareInfo,
  categoryId: categoryId ?? _categoryId,
  assignTo: assignTo ?? _assignTo,
  remark: remark ?? _remark,
  status: status ?? _status,
  createdAt: createdAt ?? _createdAt,
  updateAt: updateAt ?? _updateAt,
  product: product ?? _product,
  refferTo: refferTo ?? _refferTo,
  refferFrom: refferFrom ?? _refferFrom,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get name => _name;
  String? get mobile => _mobile;
  String? get shareInfo => _shareInfo;
  String? get categoryId => _categoryId;
  String? get assignTo => _assignTo;
  String? get remark => _remark;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updateAt => _updateAt;
  String? get product => _product;
  String? get refferTo => _refferTo;
  String? get refferFrom => _refferFrom;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['name'] = _name;
    map['mobile'] = _mobile;
    map['share_info'] = _shareInfo;
    map['category_id'] = _categoryId;
    map['assign_to'] = _assignTo;
    map['remark'] = _remark;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['update_at'] = _updateAt;
    map['product'] = _product;
    map['reffer_to'] = _refferTo;
    map['reffer_from'] = _refferFrom;
    return map;
  }

}