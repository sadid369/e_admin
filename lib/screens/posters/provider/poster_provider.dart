// ignore_for_file: unnecessary_string_interpolations

import 'dart:developer';
import 'dart:io';
import '../../../models/api_response.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/poster.dart';
import '../../../utility/snack_bar_helper.dart';

class PosterProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addPosterFormKey = GlobalKey<FormState>();
  TextEditingController posterNameCtrl = TextEditingController();
  Poster? posterForUpdate;

  File? selectedImage;
  XFile? imgXFile;

  PosterProvider(this._dataProvider);

  addPoster() async {
    try {
      if (selectedImage == null) {
        SnackBarHelper.showErrorSnackBar('Please Chose A Image');
        return;
      }
      Map<String, dynamic> fromDataMap = {
        'posterName': posterNameCtrl.text,
        'image': 'no_data' // image path will added from server side
      };
      final FormData form =
          await createFormData(imgXFile: imgXFile, formData: fromDataMap);
      final response =
          await service.addItem(endpointUrl: 'posters', itemData: form);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllPoster();
          log('Poster Added');
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to add Poster ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An Error occurred: $e');
      rethrow;
    }
  }

  updatePoster() async {
    try {
      Map<String, dynamic> fromDataMap = {
        'posterName': posterNameCtrl.text,
        'image': posterForUpdate?.imageUrl ?? ''
      };
      final FormData form =
          await createFormData(imgXFile: imgXFile, formData: fromDataMap);
      final response = await service.updateItem(
        endpointUrl: 'posters',
        itemId: posterForUpdate?.sId ?? '',
        itemData: form,
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllPoster();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Flailed to Update Poster ${apiResponse.message} ');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An Error occurred $e');
      rethrow;
    }
  }

  submitPoster() {
    if (posterForUpdate != null) {
      updatePoster();
    } else {
      addPoster();
    }
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      imgXFile = image;
      notifyListeners();
    }
  }

  deletePoster(Poster poster) async {
    try {
      Response response = await service.deleteItem(
        endpointUrl: 'posters',
        itemId: poster.sId ?? '',
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Poster Deleted Successfully');
          _dataProvider.getAllPoster();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            "Error ${response.body['message'] ?? response.statusText}");
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(
          'An Error occurred for delete Poster $e');
      rethrow;
    }
  }

  setDataForUpdatePoster(Poster? poster) {
    if (poster != null) {
      clearFields();
      posterForUpdate = poster;
      posterNameCtrl.text = poster.posterName ?? '';
    } else {
      clearFields();
    }
  }

  Future<FormData> createFormData(
      {required XFile? imgXFile,
      required Map<String, dynamic> formData}) async {
    if (imgXFile != null) {
      MultipartFile multipartFile;
      if (kIsWeb) {
        String fileName = imgXFile.name;
        Uint8List byteImg = await imgXFile.readAsBytes();
        multipartFile = MultipartFile(byteImg, filename: fileName);
      } else {
        String fileName = imgXFile.path.split('/').last;
        multipartFile = MultipartFile(imgXFile.path, filename: fileName);
      }
      formData['img'] = multipartFile;
    }
    final FormData form = FormData(formData);
    return form;
  }

  clearFields() {
    posterNameCtrl.clear();
    selectedImage = null;
    imgXFile = null;
    posterForUpdate = null;
  }
}
