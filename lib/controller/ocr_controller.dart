import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/model/id_card_model.dart';
import 'package:test/service/ocr_service.dart';

class OCRScannerController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final ocrService = OcrService();

  Rx<OCRResponse?> ocrResult = Rx<OCRResponse?>(null);

  RxBool isLoading = false.obs;

  Future<void> scanImage(File image) async {
    try {
      isLoading.value = true;
      final result = await ocrService.scanCitizenIdCard(image);
      print(result);

      ocrResult.value = result;
    } catch (e) {
      ocrResult.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
