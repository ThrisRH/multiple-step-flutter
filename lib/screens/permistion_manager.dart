import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test/core/theme/colors.dart';

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
        debugPrint("Permission denied");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Permission Manager",
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.labelGrey,
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
        ],
      ),
    );
  }
}
