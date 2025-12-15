class OCRResponse {
  final int errorCode;
  final String errorMessage;
  final CccdData data;

  OCRResponse({
    required this.errorCode,
    required this.errorMessage,
    required this.data,
  });

  factory OCRResponse.fromJson(Map<String, dynamic> json) {
    return OCRResponse(
      errorCode: json['errorCode'] ?? 0,
      errorMessage: json['errorMessage'] ?? "",
      data: CccdData.fromJson(json['data'][0]),
    );
  }
}

class CccdData {
  final String id;
  final String name;
  final String dob;
  final String sex;
  final String nationality;
  final String home;
  final String address;
  final String doe;
  final Map<String, dynamic> addressEntities;
  final String typeNew;
  final String type;

  CccdData({
    required this.id,
    required this.name,
    required this.dob,
    required this.sex,
    required this.nationality,
    required this.home,
    required this.address,
    required this.doe,
    required this.addressEntities,
    required this.typeNew,
    required this.type,
  });

  factory CccdData.fromJson(Map<String, dynamic> json) {
    return CccdData(
      id: json["id"].toString(),
      name: json["name"] ?? "",
      dob: json["dob"] ?? "",
      sex: json["sex"] ?? "",
      nationality: json["nationality"] ?? "",
      home: json["home"] ?? "",
      address: json["address"] ?? "",
      doe: json["doe"] ?? "",
      addressEntities: json["address_entities"] ?? {},
      typeNew: json["type_new"] ?? "",
      type: json["type"] ?? "",
    );
  }
}
