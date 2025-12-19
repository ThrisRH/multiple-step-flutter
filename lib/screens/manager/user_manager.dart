import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/model/id_card_model.dart';
import 'package:test/screens/manager/widgets/manager_layout.dart';
import 'package:test/service/register_service.dart';
import 'package:test/widgets/layout/multiple_form/index.dart';

class UserController extends GetxController {
  final noticeMessage = "".obs;

  var user = <UserModel>[].obs;

  final LoadingController loadingController = Get.find<LoadingController>();

  final userService = UserService();

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  void fetchUser() async {
    loadingController.isLoading.value = true;
    try {
      final response = await userService.fetchUsers();
      user.value = response;
    } catch (e) {
      noticeMessage.value = "Lấy danh sách thất bại";
    } finally {
      loadingController.isLoading.value = false;
    }
  }
}

class UserManager extends StatelessWidget {
  UserManager({super.key});

  final UserController userController = Get.put(UserController());
  final LoadingController loadingController = Get.find<LoadingController>();

  @override
  Widget build(BuildContext context) {
    return ManagerLayout(
      title: "User Manager",
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (loadingController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (userController.user.isEmpty) {
                return Center(
                  child: Text(
                    "Không có dữ liệu",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: userController.user.length,
                itemBuilder: (context, index) {
                  final user = userController.user[index];
                  return _buildUserItem(user);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(UserModel user) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Get.toNamed('/user-detail', arguments: user);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      user.personalInformation.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green, size: 18),
                  SizedBox(width: 8),
                  Text(
                    user.username,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.email, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
