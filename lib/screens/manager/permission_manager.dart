import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test/core/theme/colors.dart';
import 'package:test/screens/auth/register.dart';
import 'package:test/widgets/buttons/index.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> requestPermission({required Permission permission}) async {
      final status = await permission.status;
      if (status.isGranted) {
        debugPrint("Permission already granted");
      } else if (status.isDenied) {
        if (await permission.request().isGranted) {
          debugPrint("Permission granted");
        } else {
          debugPrint("Permission denied");
        }
      } else {
        openAppSettings();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Permission Manager",
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Camera Permission"),
            leading: Icon(Icons.camera),
            onTap: () => requestPermission(permission: Permission.camera),
          ),
          ListTile(
            title: Text("Microphone Permission"),
            leading: Icon(Icons.mic_rounded),
            onTap: () => requestPermission(permission: Permission.microphone),
          ),
          ListTile(
            title: Text("Location Permission"),
            leading: Icon(Icons.location_on_rounded),
            onTap: () => requestPermission(permission: Permission.location),
          ),
          ListTile(
            title: Text("Notification Permission"),
            leading: Icon(Icons.notifications_active),
            onTap: () => requestPermission(permission: Permission.notification),
          ),
          ListTile(
            title: Text("Photo Permission"),
            leading: Icon(Icons.photo),
            onTap: () => requestPermission(permission: Permission.photos),
          ),

          Spacer(),
          Container(
            margin: EdgeInsets.only(bottom: 24),
            padding: EdgeInsets.symmetric(horizontal: 24),
            height: 48,
            child: AppButton(
              onTap: () =>
                  Get.to(Register(), transition: Transition.noTransition),
              label: "Đăng ký tài khoản",
            ),
          ),
        ],
      ),
    );
  }
}
