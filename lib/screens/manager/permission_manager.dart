import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nabebank/core/utils/permission_status.dart';
import 'package:nabebank/screens/auth/register.dart';
import 'package:nabebank/widgets/buttons/index.dart';

class PermissionController extends GetxController {
  final locationStatus = PermissionStatus.denied.obs;
  final locationAlwaysStatus = PermissionStatus.denied.obs;
  final locationWhenInUseStatus = PermissionStatus.denied.obs;
  final photoStatus = PermissionStatus.denied.obs;
  final phoneStatus = PermissionStatus.denied.obs;
  final microStatus = PermissionStatus.denied.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() async {
    locationStatus.value = await Permission.location.status;
    locationAlwaysStatus.value = await Permission.locationAlways.status;
    locationWhenInUseStatus.value = await Permission.locationWhenInUse.status;
    photoStatus.value = await Permission.photos.status;
    phoneStatus.value = await Permission.phone.status;
    microStatus.value = await Permission.microphone.status;
  }

  void request(
    Permission permission,
    Rx<PermissionStatus> targetStatus,
    String name,
  ) async {
    final status = await permission.request();
    targetStatus.value = status;

    switch (status) {
      case PermissionStatus.granted:
        Get.snackbar("Quyền $name", "Đã cấp quyền thành công.");
        break;

      case PermissionStatus.denied:
        Get.snackbar("Quyền $name", "Đã bị từ chối.");
        break;

      case PermissionStatus.limited:
        Get.snackbar("Quyền $name", "Quyền được cấp giới hạn.");
        break;

      case PermissionStatus.permanentlyDenied:
        Get.snackbar("Quyền $name", "Quyền bị từ chối vĩnh viễn.");
        openAppSettings();
        break;

      case PermissionStatus.restricted:
        Get.snackbar("Quyền $name", "Hệ thống không cho phép quyền này.");
        openAppSettings();
        break;

      case PermissionStatus.provisional:
        Get.snackbar("Quyền $name", "Quyền được cấp tạm thời.");
        openAppSettings();
        break;
    }
  }
}

class PermissionScreen extends StatelessWidget {
  PermissionScreen({super.key});

  final controller = Get.put(PermissionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Permission Manager")),
      body: Column(
        children: [
          Obx(
            () => ListTile(
              title: const Text("Location"),
              subtitle: Text(
                statusText(controller.locationStatus.value),
                style: TextStyle(
                  color: statusColor(controller.locationStatus.value),
                ),
              ),
              leading: const Icon(Icons.location_on),
              onTap: () => controller.request(
                Permission.location,
                controller.locationStatus,
                "Vị trí",
              ),
            ),
          ),

          Obx(
            () => ListTile(
              title: const Text("Location When In Use"),
              subtitle: Text(
                statusText(controller.locationWhenInUseStatus.value),
                style: TextStyle(
                  color: statusColor(controller.locationWhenInUseStatus.value),
                ),
              ),
              leading: const Icon(Icons.my_location),
              onTap: () => controller.request(
                Permission.locationWhenInUse,
                controller.locationWhenInUseStatus,
                "Vị trí",
              ),
            ),
          ),

          Obx(
            () => ListTile(
              title: const Text("Location Always"),
              subtitle: Text(
                statusText(controller.locationAlwaysStatus.value),
                style: TextStyle(
                  color: statusColor(controller.locationAlwaysStatus.value),
                ),
              ),
              leading: const Icon(Icons.location_searching),
              onTap: () => controller.request(
                Permission.locationAlways,
                controller.locationAlwaysStatus,
                "Vị trí",
              ),
            ),
          ),

          Obx(
            () => ListTile(
              title: const Text("Photos"),
              subtitle: Text(
                statusText(controller.photoStatus.value),
                style: TextStyle(
                  color: statusColor(controller.photoStatus.value),
                ),
              ),
              leading: const Icon(Icons.photo),
              onTap: () => controller.request(
                Permission.photos,
                controller.photoStatus,
                "Vị trí",
              ),
            ),
          ),

          Obx(
            () => ListTile(
              title: const Text("Microphone"),
              subtitle: Text(
                statusText(controller.microStatus.value),
                style: TextStyle(
                  color: statusColor(controller.microStatus.value),
                ),
              ),
              leading: const Icon(Icons.storage),
              onTap: () => controller.request(
                Permission.microphone,
                controller.microStatus,
                "Thu âm",
              ),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(24),
            child: AppButton(
              label: "Đăng ký tài khoản",
              onTap: () =>
                  Get.to(Register(), transition: Transition.noTransition),
            ),
          ),
        ],
      ),
    );
  }
}
