// ignore_for_file: unnecessary_string_interpolations

import 'dart:developer';

import '../../../models/variant_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/variant.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class VariantsProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addVariantsFormKey = GlobalKey<FormState>();
  TextEditingController variantCtrl = TextEditingController();
  VariantType? selectedVariantType;
  Variant? variantForUpdate;

  VariantsProvider(this._dataProvider);

  addVariant() async {
    try {
      //
      Map<String, dynamic> variant = {
        'name': variantCtrl.text,
        'variantTypeId': selectedVariantType?.sId
      };
      final response =
          await service.addItem(endpointUrl: 'variants', itemData: variant);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('Variant Added Successfully');
          log('Variant Added');
          _dataProvider.getAllVariant();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to Add Variant ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Failed to Add Subcategory ${response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An Error Occurred $e');
      rethrow;
    }
  }

  updateVariant() async {
    try {
      //
      if (variantForUpdate != null) {
        Map<String, dynamic> variant = {
          'name': variantCtrl.text,
          'variantTypeId': selectedVariantType?.sId,
        };
        final Response response = await service.updateItem(
          endpointUrl: 'variants',
          itemId: variantForUpdate?.sId ?? '',
          itemData: variant,
        );
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar(' ${apiResponse.message}');
            log('Variant Updated');
            _dataProvider.getAllVariant();
          } else {
            SnackBarHelper.showErrorSnackBar(
              'Failed to Variant ${apiResponse.message}',
            );
          }
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to Add Variant ${response.statusText}');
        }
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error to Update Variant $e');
      rethrow;
    }
  }

  submitVariant() {
    if (variantForUpdate != null) {
      updateVariant();
    } else {
      addVariant();
    }
  }

  deleteVariant(Variant variant) async {
    try {
      Response response = await service.deleteItem(
        endpointUrl: 'variants',
        itemId: variant.sId ?? '',
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('Variant Deleted Successfully');
          _dataProvider.getAllVariant();
        } else {
          SnackBarHelper.showErrorSnackBar('${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body['message'] ?? response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(
          'An Error occurred for delete Variant $e');
      rethrow;
    }
  }

  setDataForUpdateVariant(Variant? variant) {
    if (variant != null) {
      variantForUpdate = variant;
      variantCtrl.text = variant.name ?? '';
      selectedVariantType = _dataProvider.variantTypes.firstWhereOrNull(
          (element) => element.sId == variant.variantTypeId?.sId);
    } else {
      clearFields();
    }
  }

  clearFields() {
    variantCtrl.clear();
    selectedVariantType = null;
    variantForUpdate = null;
  }

  void updateUI() {
    notifyListeners();
  }
}
