import 'local_user.dart';

class Lesson{
  int _id, _sessionCode;
  String _name;
  DateTime _createdTime;
  LocalUser _createdBy;

  Lesson(this._sessionCode, this._name, this._createdTime, this._createdBy);

  Lesson.withID(this._id, this._sessionCode, this._name, this._createdTime,
      this._createdBy);

  LocalUser get createdBy => _createdBy;

  set createdBy(LocalUser value) {
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

  @override
  String toString() {
    return 'Lesson{_id: $_id, _sessionCode: $_sessionCode, _name: $_name, _createdTime: $_createdTime, _createdBy: $_createdBy}';
  }
}