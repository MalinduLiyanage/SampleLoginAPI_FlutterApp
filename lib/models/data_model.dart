class UserData {
  final String userCode;
  final String userDisplayName;
  final String email;
  final String userEmployeeCode;
  final String companyCode;

  UserData({
    required this.userCode,
    required this.userDisplayName,
    required this.email,
    required this.userEmployeeCode,
    required this.companyCode,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      userCode: map['User_Code'],
      userDisplayName: map['User_Display_Name'],
      email: map['Email'],
      userEmployeeCode: map['User_Employee_Code'],
      companyCode: map['Company_Code'],
    );
  }
}

class UserLocation {
  final int locationId;
  final String userCode;
  final String locationCode;

  UserLocation({
    required this.locationId,
    required this.userCode,
    required this.locationCode,
  });

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      locationId: map['Location_Id'],
      userCode: map['User_Code'],
      locationCode: map['Location_Code'],
    );
  }
}

class UserPermission {
  final int permissionId;
  final String userCode;
  final String permissionName;
  final String permissionStatus;

  UserPermission({
    required this.permissionId,
    required this.userCode,
    required this.permissionName,
    required this.permissionStatus,
  });

  factory UserPermission.fromMap(Map<String, dynamic> map) {
    return UserPermission(
      permissionId: map['Permission_Id'],
      userCode: map['User_Code'],
      permissionName: map['Permission_Name'],
      permissionStatus: map['Permission_Status'],
    );
  }
}
