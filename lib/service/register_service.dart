// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'package:dio/dio.dart';
import 'package:nabebank/constant/api.dart';
import 'package:nabebank/model/id_card_model.dart';

class UserService {
  final dio = Dio();

  Future<bool> checkValidPhoneEmail(String phone, String email) async {
    final String PHONE_EMAIL_CHECKING_API =
        "$API_HOST/users?filters[\$or][0][username][\$contains]=$phone&filters[\$or][1][email][\$contains]=$email";
    final reponse = await dio.get(PHONE_EMAIL_CHECKING_API);
    if (!reponse.data.isEmpty) {
      return true; // Have data => phone or email exist
    }
    return false;
  }

  Future<Map<String, dynamic>> registerAccount(RegisterRequest payload) async {
    final String CREATE_ACCOUNT_API = "$API_HOST/auth/local/register";
    final String CREATE_USER_INFO = "$API_HOST/personal-informations";
    try {
      Map<String, dynamic>? _userInfo;

      final userData = await dio.post(
        CREATE_ACCOUNT_API,
        data: {
          'username': payload.phone,
          'email': payload.email,
          'password': payload.password,
        },
      );
      final userResponse = userData.data['user'];

      if (userResponse != null) {
        final userInfo = await dio.post(
          CREATE_USER_INFO,
          data: {
            'data': {
              'name': payload.personalInformation.name,
              'id_card': payload.personalInformation.idCard,
              'sex': payload.personalInformation.sex,
              'home': payload.personalInformation.home,
              'address': payload.personalInformation.address,
              'nationality': payload.personalInformation.nationality,
              'dob': payload.personalInformation.dob,
              'doe': payload.personalInformation.doe,
              'address_entities': payload.personalInformation.addressEntities,
              'users_permissions_user': userResponse['id'],
            },
          },
        );

        if (userInfo.data != null) {
          _userInfo = userInfo.data;
        }
      }

      if (_userInfo == null) {
        return {"isSuccess": false, "errorMessage": "Failed to create account"};
      }

      return {"isSuccess": true, "errorMessage": ""};
    } on DioException catch (e) {
      return {"isSuccess": false, "errorMessage": "${e.message}"};
    } catch (e) {
      return {"isSuccess": false, "errorMessage": "$e"};
    }
  }

  Future<List<UserModel>> fetchUsers() async {
    final response = await dio.get(
      '$API_HOST/users?populate[personal_information][populate]=address_entities',
    );

    final List<dynamic> jsonList = response.data;

    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }
}
