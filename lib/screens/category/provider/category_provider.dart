// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';
import 'package:e_admin/models/api_response.dart';
import 'package:e_admin/utility/snack_bar_helper.dart';

import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';

class CategoryProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addCategoryFormKey = GlobalKey<FormState>();
  TextEditingController categoryNameCtrl = TextEditingController();
  Category? categoryForUpdate;

  File? selectedImage;
  XFile? imgXFile;

  CategoryProvider(this._dataProvider);

  addCategory() async {
    try {
      if (selectedImage == null) {
        SnackBarHelper.showErrorSnackBar('Please Chose A Image');
      }
      Map<String, dynamic> fromDataMap = {
        'name': categoryNameCtrl.text,
        'image': 'no_data'
      };
      final FormData form =
          await createFormData(imgXFile: imgXFile, formData: fromDataMap);
      final response =
          await service.addItem(endpointUrl: 'categories', itemData: form);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllCategory();
          log('Category Added');
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to add category ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An Error occurred: $e');
      rethrow;
    }
  }

  updateCategory() async {
    try {
      Map<String, dynamic> fromDataMap = {
        'name': categoryNameCtrl.text,
        'image': categoryForUpdate?.image ?? ''
      };
      final FormData form =
          await createFormData(imgXFile: imgXFile, formData: fromDataMap);
      final response = await service.updateItem(
        endpointUrl: 'categories',
        itemId: categoryForUpdate?.sId ?? '',
        itemData: form,
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
          _dataProvider.getAllCategory();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Flailed to Update Category ${apiResponse.message} ');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An Error occurred $e');
      rethrow;
    }
  }

  submitCategory() {
    if (categoryForUpdate != null) {
      updateCategory();
    } else {
      addCategory();
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

  deleteCategory(Category category) async {
    try {
      Response response = await service.deleteItem(
        endpointUrl: 'categories',
        itemId: category.sId ?? '',
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Category Deleted Successfully');
          _dataProvider.getAllCategory();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            "Error ${response.body['message'] ?? response.statusText}");
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar(
          'An Error occurred for delete Category $e');
      rethrow;
    }
  }

  //? to create form data for sending image with body
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

  //? set data for update on editing
  setDataForUpdateCategory(Category? category) {
    if (category != null) {
      clearFields();
      categoryForUpdate = category;
      categoryNameCtrl.text = category.name ?? '';
    } else {
      clearFields();
    }
  }

  //? to clear text field and images after adding or update category
  clearFields() {
    categoryNameCtrl.clear();
    selectedImage = null;
    imgXFile = null;
    categoryForUpdate = null;
  }
}
