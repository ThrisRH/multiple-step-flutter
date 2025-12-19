import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/core/theme/colors.dart';
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
    return Container(
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
                spacing: 24,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.labelGrey,
                    ),
                    child: Center(
                      child: Icon(Icons.person, color: AppColors.darkBlue),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.personalInformation.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.labelGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: AppColors.darkBlue,
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
