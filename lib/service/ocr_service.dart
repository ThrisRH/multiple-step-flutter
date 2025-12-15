import 'dart:io';
import 'package:dio/dio.dart';
import 'package:test/model/id_card_model.dart';

class OcrService {
  final Dio dio = Dio();

  Future<OCRResponse> scanCitizenIdCard(File image) async {
    const url = 'https://api.fpt.ai/vision/idr/vnm/';

    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });
    try {
      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {'api_key': 'V5EEVHG19QrInlL9vlXZFElGplD2s0dw'},
        ),
      );

      final ocrData = OCRResponse.fromJson(response.data);

      return ocrData;
    } catch (e) {
      if (e is DioException) {
        throw Exception("DioError: ${e.response?.data ?? e.message}");
      }
      throw Exception("ServerError: $e");
    }
  }
}
