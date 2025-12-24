import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabebank/model/id_card_model.dart';
import 'package:nabebank/screens/manager/widgets/manager_layout.dart';
import 'package:nabebank/widgets/common/info_container.dart';
import 'package:nabebank/widgets/common/info_row.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = Get.arguments;

    return ManagerLayout(
      title: "Chi tiết người dùng",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin cơ bản
            InfoBoxContainer(
              title: "Thông tin tài khoản",
              children: [
                InfoRow("Username", user.username),
                InfoRow("Email", user.email),
              ],
            ),

            InfoBoxContainer(
              title: "Thông tin cá nhân",
              children: [
                InfoRow("Họ và tên", user.personalInformation.name),
                InfoRow("Số CMND/CCCD", user.personalInformation.idCard),
                InfoRow("Giới tính", user.personalInformation.sex),
                InfoRow("Quốc tịch", user.personalInformation.nationality),
                InfoRow("Ngày sinh", user.personalInformation.dob),
                InfoRow("Ngày hết hạn", user.personalInformation.doe),
                InfoRow("Địa chỉ thường trú", user.personalInformation.address),
                InfoRow("Nguyên quán", user.personalInformation.home),
              ],
            ),

            InfoBoxContainer(
              title: "Địa chỉ chi tiết",
              children: [
                InfoRow(
                  "Tỉnh/Thành phố",
                  user.personalInformation.addressEntities.province,
                ),
                InfoRow(
                  "Quận/Huyện",
                  user.personalInformation.addressEntities.district,
                ),
                InfoRow(
                  "Phường/Xã",
                  user.personalInformation.addressEntities.ward,
                ),
                InfoRow(
                  "Đường",
                  user.personalInformation.addressEntities.street,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
