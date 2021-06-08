class LocalUser {

  String _firstName, _lastName, _eMail, _password,  _userType;


  LocalUser(this._firstName, this._lastName, this._eMail, this._password,
      this._userType);

  get userType => _userType;

  set userType(value) {
    _userType = value;
  }

  get eMail => _eMail;

  set eMail(value) {
    _eMail = value;
  }

  get lastName => _lastName;

  set lastName(value) {
    _lastName = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  @override
  String toString() {
    return 'LocalUser{_firstName: $_firstName, _lastName: $_lastName, _eMail: $_eMail, _userType: $_userType}';
  }


  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['_firstName'] = _firstName;
    map['_lastName'] = _lastName;
    map['_eMail'] = _eMail;
    map['_password'] = _password;
    map['_userType'] = _userType;
    return map;
  }

  LocalUser.fromMap(Map<String, dynamic> map) {
    this._firstName = map['_firstName'];
    this._lastName = map['_lastName'];
    this._eMail = map['_eMail'];
    this._password = map['_password'];
    this._userType = map['_userType'];
  }
}