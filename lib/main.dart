import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:nabebank/controller/ocr_controller.dart';
import 'package:nabebank/screens/auth/register.dart';
import 'package:nabebank/screens/image_crop/index.dart';
import 'package:nabebank/screens/manager/permission_manager.dart';
import 'package:nabebank/screens/manager/user_detail.dart';
import 'package:nabebank/screens/manager/user_manager.dart';
import 'package:nabebank/widgets/layout/multiple_form/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  Get.put(OCRScannerController());
  Get.put(LoadingController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/image-crop',
        getPages: [
          GetPage(name: '/user-manager', page: () => UserManager()),
          GetPage(name: '/permission', page: () => PermissionScreen()),
          GetPage(name: '/user-detail', page: () => UserDetail()),
          GetPage(name: '/auth/register', page: () => Register()),
          GetPage(name: '/image-crop', page: () => ImageCropScreen()),
        ],
      ),
    );
  }
}
