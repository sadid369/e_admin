// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:e_admin/models/api_response.dart';
import 'package:e_admin/utility/snack_bar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../models/sub_category.dart';
import '../../../services/http_services.dart';

class SubCategoryProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addSubCategoryFormKey = GlobalKey<FormState>();
  TextEditingController subCategoryNameCtrl = TextEditingController();
  Category? selectedCategory;
  SubCategory? subCategoryForUpdate;

  SubCategoryProvider(this._dataProvider);

  //TODO: should complete addSubCategory

  addSubCategory() async {
    try {
      //
      Map<String, dynamic> subCategory = {
        'name': subCategoryNameCtrl.text,
        'categoryId': selectedCategory?.sId
      };
      final response = await service.addItem(
          endpointUrl: 'subCategories', itemData: subCategory);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('SubCategory Added Successfully');
          log('Subcategory Added');
          _dataProvider.getAllSubCategory();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to Add Subcategory ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to Add Subcategory ${response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An Error Occurred $e');
      rethrow;
    }
  }

  updateSubCategory() async {
    try {
      //
      if (subCategoryForUpdate != null) {
        Map<String, dynamic> subCategory = {
          'name': subCategoryNameCtrl.text,
          'categoryId': selectedCategory?.sId,
        };
        final Response response = await service.updateItem(
          endpointUrl: 'subCategories',
          itemId: subCategoryForUpdate?.sId ?? '',
          itemData: subCategory,
        );
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar(
                'SubCategory Update Successfully ${apiResponse.message}');
            log('SubCategory Updated');
            _dataProvider.getAllSubCategory();
          } else {
            SnackBarHelper.showErrorSnackBar(
                'Failed to Subcategory ${apiResponse.message}');
          }
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to Add SubCategory ${response.statusText}');
        }
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Error to Update SubCategory $e');
      rethrow;
    }
  }

  submitSubCategory() {
    if (subCategoryForUpdate != null) {
      updateSubCategory();
    } else {
      addSubCategory();
    }
  }

  //TODO: should complete deleteSubCategory

  setDataForUpdateCategory(SubCategory? subCategory) {
    if (subCategory != null) {
      subCategoryForUpdate = subCategory;
      subCategoryNameCtrl.text = subCategory.name ?? '';
      selectedCategory = _dataProvider.categories.firstWhereOrNull(
          (element) => element.sId == subCategory.categoryId?.sId);
    } else {
      clearFields();
    }
  }

  clearFields() {
    subCategoryNameCtrl.clear();
    selectedCategory = null;
    subCategoryForUpdate = null;
  }

  updateUi() {
    notifyListeners();
  }
}
