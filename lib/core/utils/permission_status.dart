import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Color statusColor(PermissionStatus status) {
  switch (status) {
    case PermissionStatus.granted:
      return Colors.green;

    case PermissionStatus.limited:
      return Colors.orange;

    case PermissionStatus.denied:
      return Colors.red;

    case PermissionStatus.permanentlyDenied:
      return Colors.grey;

    default:
      return Colors.black54;
  }
}

String statusText(PermissionStatus status) {
  switch (status) {
    case PermissionStatus.granted:
      return "Đã cấp quyền";

    case PermissionStatus.limited:
      return "Giới hạn";

    case PermissionStatus.denied:
      return "Đã từ chối";

    case PermissionStatus.permanentlyDenied:
      return "Bị chặn vĩnh viễn";

    case PermissionStatus.restricted:
      return "Hệ thống không cho phép";

    case PermissionStatus.provisional:
      return "Cấp quyền tạm thời";
  }
}
