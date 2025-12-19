import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/model/id_card_model.dart';
import 'package:test/screens/manager/widgets/manager_layout.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin cơ bản
            _buildSectionTitle("Thông tin tài khoản"),
            _buildInfoCard([
              _buildInfoRow("ID", user.id.toString()),
              _buildInfoRow("Username", user.username),
              _buildInfoRow("Email", user.email),
            ]),

            SizedBox(height: 24),

            // Thông tin cá nhân
            _buildSectionTitle("Thông tin cá nhân"),
            _buildInfoCard([
              _buildInfoRow("Họ và tên", user.personalInformation.name),
              _buildInfoRow("Số CMND/CCCD", user.personalInformation.idCard),
              _buildInfoRow("Giới tính", user.personalInformation.sex),
              _buildInfoRow("Quốc tịch", user.personalInformation.nationality),
              _buildInfoRow("Ngày sinh", user.personalInformation.dob),
              _buildInfoRow("Ngày hết hạn", user.personalInformation.doe),
              _buildInfoRow(
                "Địa chỉ thường trú",
                user.personalInformation.address,
              ),
              _buildInfoRow("Nguyên quán", user.personalInformation.home),
            ]),

            SizedBox(height: 24),

            // Thông tin địa chỉ chi tiết
            _buildSectionTitle("Địa chỉ chi tiết"),
            _buildInfoCard([
              _buildInfoRow(
                "Tỉnh/Thành phố",
                user.personalInformation.addressEntities.province,
              ),
              _buildInfoRow(
                "Quận/Huyện",
                user.personalInformation.addressEntities.district,
              ),
              _buildInfoRow(
                "Phường/Xã",
                user.personalInformation.addressEntities.ward,
              ),
              _buildInfoRow(
                "Đường",
                user.personalInformation.addressEntities.street,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "Chưa cập nhật",
              style: TextStyle(
                color: value.isNotEmpty ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
