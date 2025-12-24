import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nabebank/screens/image_crop/action_description.dart';
import 'package:nabebank/screens/manager/widgets/manager_layout.dart';
import 'package:nabebank/widgets/buttons/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class ImageCropController extends GetxController {
  final photoStatus = PermissionStatus.denied.obs;
  final permission = Permission.photos;
  final List<CroppedFile> croppedFileList = [];

  final currentStatusTitle = "".obs;
  final guide = "".obs;
  final showPopup = false.obs;
  final permissionName = "".obs;

  final isPDFCroppedSuccess = false.obs;
  final isProcessing = false.obs;

  void openPopup() => showPopup.value = true;
  void closePopup() => showPopup.value = false;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void setWording(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.limited:
      case PermissionStatus.granted:
        currentStatusTitle.value = "Chọn hình ảnh";
        guide.value = "Bạn có thể chọn 1 hoặc nhiều ảnh để bắt đầu chỉnh sửa.";
        break;
      case PermissionStatus.denied:
        currentStatusTitle.value =
            "Quyền truy cập hình ảnh hiện chưa được cấp phép";
        guide.value =
            "Vui lòng bấm vào nút 'Bật' để cho phép ứng dụng truy cập vào thư mục ảnh";
        break;

      case PermissionStatus.permanentlyDenied:
        currentStatusTitle.value =
            "Quyền truy cập hình ảnh \nkhông được cho phép";
        guide.value =
            "Vui lòng thực hiện theo các bước sau: \n1. Bấm vào nút 'Bật' \n2. Bấm vào 'Đi đến cài đặt' \n3. Chọn 'Quyền riêng tư & Bảo mật' \n4. Tìm và chọn 'Hình ảnh' \n5. Chọn ứng dụng 'NabeBank' \n6. Chọn 'Truy cập đầy đủ' hoặc 'Truy cập giới hạn'";
        break;

      default:
        break;
    }
  }

  Future<void> load() async {
    photoStatus.value = await permission.status;

    setWording(photoStatus.value);
  }

  void clear() {
    isPDFCroppedSuccess.value = false;
    croppedFileList.clear();
    isProcessing.value = false;
    setWording(photoStatus.value);
  }

  Future<List<XFile>> pickImageFromGallery() async {
    final List<XFile> imageFileList = [];

    final List<XFile> selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    return imageFileList;
  }

  Future<void> cropImage(List<XFile> images) async {
    try {
      croppedFileList.clear();
      for (final item in images) {
        CroppedFile? cropperFile = await ImageCropper().cropImage(
          sourcePath: item.path,
          uiSettings: [
            IOSUiSettings(
              title: 'Chỉnh sửa hình ảnh',
              doneButtonTitle: 'Lưu',
              cancelButtonTitle: 'Hủy',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
          ],
        );

        if (cropperFile != null) {
          croppedFileList.add(cropperFile);
        }
      }

      if (croppedFileList.isEmpty) {
        isPDFCroppedSuccess.value = false;
        return;
      }

      // Have item in [croppedFileList]
      isPDFCroppedSuccess.value = true;
    } catch (e) {
      isPDFCroppedSuccess.value = false;
    }
  }

  Future<void> handlePopupCase(String name) async {
    final status = photoStatus.value;
    permissionName.value = name;

    switch (status) {
      case PermissionStatus.limited:
      case PermissionStatus.granted:
        final images = await pickImageFromGallery();
        if (images.isNotEmpty) {
          await cropImage(images);
        }
        break;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
        openPopup();
        break;

      default:
        Get.snackbar("Quyền $name", "Đã bị chặn hoặc không khả dụng.");
        break;
    }
  }

  Future<void> request() async {
    final status = photoStatus.value;

    if (status.isGranted || status.isLimited) {
      setWording(status);
      closePopup();
      return;
    }

    if (status.isDenied) {
      final newStatus = await permission.request();
      photoStatus.value = newStatus;
      setWording(newStatus);
      closePopup();

      if (newStatus.isGranted || newStatus.isLimited) {
        closePopup();
      }

      return;
    }

    if (status.isPermanentlyDenied) {
      setWording(status);
      openAppSettings();
      closePopup();
    }
  }

  Future<File> convertImagesToPdf(List<CroppedFile> imagesList) async {
    try {
      final pdf = pw.Document();

      for (final item in imagesList) {
        final imageBytes = await item.readAsBytes();
        final pdfImage = pw.MemoryImage(imageBytes);

        pdf.addPage(
          pw.Page(
            build: (context) {
              return pw.Center(
                child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
              );
            },
          ),
        );
      }

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/nabe_edit_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      await file.writeAsBytes(await pdf.save());
      isPDFCroppedSuccess.value = true;
      return file;
    } catch (e) {
      isPDFCroppedSuccess.value = false;
      rethrow;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> sharePdf(File pdfFile) async {
    final params = ShareParams(files: [XFile(pdfFile.path)]);
    await SharePlus.instance.share(params);
  }

  void handleSavePDF() async {
    if (croppedFileList.isNotEmpty) {
      final pdf = await convertImagesToPdf(croppedFileList);
      await sharePdf(pdf);
    }
  }
}

class ImageCropScreen extends StatelessWidget {
  ImageCropScreen({super.key});
  final ImageCropController controller = Get.put(ImageCropController());

  @override
  Widget build(BuildContext context) {
    return ManagerLayout(
      title: "Image Crop Feature",
      child: Padding(
        padding: EdgeInsetsGeometry.all(16.0),
        child: Column(
          spacing: 24,
          children: [
            Obx(() {
              if (controller.isPDFCroppedSuccess.value) {
                if (controller.isProcessing.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ActionDescription(
                    title:
                        "Các ảnh đã được cắt và chuyển thành PDF. Hãy lưu lại nhé.",
                    guide:
                        "Bạn có thể tìm thấy file PDF trong ứng dụng 'Tệp' và tại nơi bạn đã lưu.",
                    imagePath: 'lib/asset/image/pdf_success.png',
                  );
                }
              } else {
                return ActionDescription(
                  title: controller.currentStatusTitle.value,
                  guide: controller.guide.value,
                  imagePath: "lib/asset/image/crop_image.png",
                );
              }
            }),
            Obx(() {
              if (controller.isPDFCroppedSuccess.value) {
                return Column(
                  spacing: 12,
                  children: [
                    AppButton(
                      onTap: () {
                        controller.handleSavePDF();
                      },
                      label: "Lưu file PDF",
                    ),
                    AppBorderButton(
                      onTap: () {
                        controller.clear();
                      },
                      label: "Tạo ảnh mới",
                    ),
                  ],
                );
              } else if (controller.photoStatus.value ==
                      PermissionStatus.granted ||
                  controller.photoStatus.value == PermissionStatus.limited) {
                return AppButton(
                  onTap: () {
                    controller.handlePopupCase("Thư viện ảnh");
                  },
                  label: "Chọn ảnh",
                );
              } else {
                return AppButton(
                  onTap: () {
                    controller.handlePopupCase("Thư viện ảnh");
                  },
                  label: "Bật",
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
