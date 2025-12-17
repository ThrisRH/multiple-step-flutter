import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/model/id_card_model.dart';
import 'package:test/service/ocr_service.dart';

class OCRScannerController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final ocrService = OcrService();

  // Rx<OCRResponse?> ocrResult = Rx<OCRResponse?>(null);

  Rx<OCRResponse?> ocrResult = Rx<OCRResponse?>(
    OCRResponse(
      data: CccdData(
        id: "001204014664",
        name: "NGUYỄN MINH QUÂN",
        dob: "09/09/2004",
        sex: "NAM",
        nationality: "VIỆT NAM",
        home: "Hòa Long, Thành Phố Bắc Ninh, Bắc Ninh",
        address: "218C Đội Cấn Liễu Giai, Ba Đình, Hà Nội",
        doe: "09/09/2029",
        addressEntities: {
          "province": "Hà Nội",
          "district": "Ba Đình",
          "ward": "Liễu Giai",
          "street": "Đội Cấn",
        },
        typeNew: "cmnd_12_front",
        type: "new",
      ),
      errorCode: 200,
      errorMessage: '',
    ),
  );

  RxBool isLoading = false.obs;

  Future<void> scanImage(File image) async {
    try {
      isLoading.value = true;
      final result = await ocrService.scanCitizenIdCard(image);

      ocrResult.value = result;
    } catch (e) {
      ocrResult.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
