class Lesson {
  int _id, _sessionCode;
  String _name;
  DateTime _createdTime;
  String _createdBy;

  Lesson(this._sessionCode, this._name, this._createdTime, this._createdBy);

  Lesson.withID(this._id, this._sessionCode, this._name, this._createdTime,
      this._createdBy);

  String get createdBy => _createdBy;

  set createdBy(String value) {
    _createdBy = value;
  }

  DateTime get createdTime => _createdTime;

  set createdTime(DateTime value) {
    _createdTime = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  get sessionCode => _sessionCode;

  set sessionCode(value) {
    _sessionCode = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['sessionCode'] = _sessionCode;
    map['name'] = _name;
    map['createdTime'] = _createdTime;
    map['createdBy'] = _createdBy;
    return map;
  }

  Lesson.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._sessionCode = map['sessionCode'];
    this._name = map['name'];
    this._createdTime = map['createdTime'];
    this._createdBy = map['createdBy'];
  }

  @override
  String toString() {
    return 'Lesson{_id: $_id, _sessionCode: $_sessionCode, _name: $_name, _createdTime: $_createdTime, _createdBy: $_createdBy}';
  }
}
