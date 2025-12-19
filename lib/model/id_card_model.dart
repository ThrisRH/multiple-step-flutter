class PersonalInformation {
  final String name;
  final String idCard;
  final String sex;
  final String nationality;
  final String home;
  final String address;
  final AddressEntities addressEntities;
  final String dob;
  final String doe;

  PersonalInformation({
    required this.name,
    required this.idCard,
    required this.sex,
    required this.nationality,
    required this.home,
    required this.address,
    required this.dob,
    required this.doe,
    required this.addressEntities,
  });

  factory PersonalInformation.fromJson(Map<String, dynamic> json) {
    return PersonalInformation(
      name: json['name'] ?? '',
      idCard: json['id_card'] ?? '',
      sex: json['sex'] ?? '',
      nationality: json['nationality'] ?? '',
      addressEntities: AddressEntities.fromJson(json['address_entities'] ?? {}),
      home: json['home'] ?? '',
      address: json['address'] ?? '',
      dob: json['dob'] ?? '',
      doe: json['doe'] ?? '',
    );
  }
}

class AddressEntities {
  final String province;
  final String district;
  final String ward;
  final String street;

  AddressEntities({
    required this.province,
    required this.district,
    required this.ward,
    required this.street,
  });

  factory AddressEntities.fromJson(Map<String, dynamic> json) {
    return AddressEntities(
      province: json['province'] ?? '',
      district: json['district'] ?? '',
      ward: json['ward'] ?? '',
      street: json['street'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "province": province,
      "district": district,
      "ward": ward,
      "street": street,
    };
  }
}

class UserModel {
  final int id;
  final String username;
  final String email;
  final PersonalInformation personalInformation;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.personalInformation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      personalInformation: PersonalInformation.fromJson(
        json['personal_information'],
      ),
    );
  }
}

class OCRResponse {
  final int errorCode;
  final String errorMessage;
  final PersonalInformation data;

  OCRResponse({
    required this.errorCode,
    required this.errorMessage,
    required this.data,
  });

  factory OCRResponse.fromJson(Map<String, dynamic> json) {
    return OCRResponse(
      errorCode: json['errorCode'] ?? 0,
      errorMessage: json['errorMessage'] ?? '',
      data: PersonalInformation.fromJson(json['data'][0]),
    );
  }
}

class RegisterRequest {
  final String phone;
  final String email;
  final String password;
  final PersonalInformation personalInformation;

  RegisterRequest({
    required this.phone,
    required this.email,
    required this.password,
    required this.personalInformation,
  });
}
