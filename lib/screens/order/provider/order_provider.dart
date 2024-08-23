// ignore_for_file: unnecessary_string_interpolations

import 'dart:developer';

import 'package:get/get.dart';

import '../../../models/api_response.dart';
import '../../../models/order.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';
import '../../../utility/snack_bar_helper.dart';

class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final orderFormKey = GlobalKey<FormState>();
  TextEditingController trackingUrlCtrl = TextEditingController();
  String selectedOrderStatus = 'pending';
  Order? orderForUpdate;

  OrderProvider(this._dataProvider);

  updateOrder() async {
    try {
      if (orderForUpdate != null) {
        Map<String, dynamic> order = {
          "orderStatus": selectedOrderStatus,
          "trackingUrl": trackingUrlCtrl.text,
        };
        final Response response = await service.updateItem(
          endpointUrl: 'orders',
          itemId: orderForUpdate?.sId ?? '',
          itemData: order,
        );
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            SnackBarHelper.showSuccessSnackBar(' ${apiResponse.message}');
            log('Order Updated');
            _dataProvider.getAllOrders();
          } else {
            SnackBarHelper.showErrorSnackBar(
              'Failed to Order ${apiResponse.message}',
            );
          }
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to Update Order ${response.statusText}');
        }
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error to Update Order $e');
      rethrow;
    }
  }

  deleteOrder(Order order) async {
    try {
      Response response = await service.deleteItem(
        endpointUrl: 'orders',
        itemId: order.sId ?? '',
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('Order Deleted Successfully');
          _dataProvider.getAllOrders();
        } else {
          SnackBarHelper.showErrorSnackBar('${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body['message'] ?? response.statusText}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An Error occurred for delete Order $e');
      rethrow;
    }
  }

  updateUI() {
    notifyListeners();
  }
}
