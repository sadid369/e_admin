// ignore_for_file: unnecessary_string_interpolations

import 'dart:developer';

import 'package:e_admin/models/api_response.dart';
import 'package:e_admin/utility/snack_bar_helper.dart';

import '../../../models/brand.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/sub_category.dart';
import '../../../services/http_services.dart';

class BrandProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addBrandFormKey = GlobalKey<FormState>();
  TextEditingController brandNameCtrl = TextEditingController();
  SubCategory? selectedSubCategory;
  Brand? brandForUpdate;

  BrandProvider(this._dataProvider);

  addBrand() async {
    try {
      Map<String, dynamic> brand = {
        'name': brandNameCtrl.text,
        'subcategoryId': selectedSubCategory?.sId
      };
      final response =
          await service.addItem(endpointUrl: 'brands', itemData: brand);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success) {
          clearFields();
          log('Brand Added');
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllBrands();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to add brand ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An Error Occurred: $e ');
      rethrow;
    }
  }

  updateBrand() async {
    try {
      //
      if (brandForUpdate != null) {
        Map<String, dynamic> brands = {
          'name': brandNameCtrl.text,
          'subcategoryId': selectedSubCategory?.sId,
        };
        final Response response = await service.updateItem(
          endpointUrl: 'brands',
          itemId: brandForUpdate?.sId ?? '',
          itemData: brands,
        );
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar(' ${apiResponse.message}');
            log('brand updated');
            _dataProvider.getAllBrands();
          } else {
            log('here');
            SnackBarHelper.showErrorSnackBar(
                'Failed to Brand ${apiResponse.message}');
          }
        } else {
          log('here 2');
          SnackBarHelper.showErrorSnackBar(
              'Failed to Add Brand ${response.statusText}');
        }
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error to Update Brand $e');
      rethrow;
    }
  }

  deleteBrand(Brand brand) async {
    try {
      Response response = await service.deleteItem(
        endpointUrl: 'brands',
        itemId: brand.sId ?? '',
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('Brand Deleted Successfully');
          _dataProvider.getAllBrands();
        } else {
          SnackBarHelper.showErrorSnackBar('${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body['message'] ?? response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An Error occurred for delete Brand $e');
      rethrow;
    }
  }

  //? set data for update on editing
  setDataForUpdateBrand(Brand? brand) {
    if (brand != null) {
      brandForUpdate = brand;
      brandNameCtrl.text = brand.name ?? '';
      selectedSubCategory = _dataProvider.subCategories.firstWhereOrNull(
          (element) => element.sId == brand.subcategoryId?.sId);
    } else {
      clearFields();
    }
  }

  //? to clear text field and images after adding or update brand
  clearFields() {
    brandNameCtrl.clear();
    selectedSubCategory = null;
    brandForUpdate = null;
  }

  submitBrand() {
    if (brandForUpdate != null) {
      updateBrand();
    } else {
      addBrand();
    }
  }

  updateUI() {
    notifyListeners();
  }
}
