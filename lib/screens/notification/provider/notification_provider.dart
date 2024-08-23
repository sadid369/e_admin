// ignore_for_file: unnecessary_string_interpolations

import 'dart:developer';

import 'package:e_admin/models/my_notification.dart';
import 'package:get/get.dart';

import '../../../models/api_response.dart';
import '../../../models/notification_result.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class NotificationProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final sendNotificationFormKey = GlobalKey<FormState>();

  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController imageUrlCtrl = TextEditingController();

  NotificationResult? notificationResult;

  NotificationProvider(this._dataProvider);

  sendNotification() async {
    try {
      Map<String, dynamic> notification = {
        "title": titleCtrl.text,
        "description": descriptionCtrl.text,
        "imageUrl": imageUrlCtrl.text,
      };

      final response = await service.addItem(
          endpointUrl: 'notification/send-notification',
          itemData: notification);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllNotifications();
          log('Notification Send');
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Failed to Send Notification  ${apiResponse.message}');
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

  deleteNotification(MyNotification myNotification) async {
    try {
      Response response = await service.deleteItem(
        endpointUrl: 'notification/delete-notification',
        itemId: myNotification.sId ?? '',
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(
              'Notification  Deleted Successfully');
          _dataProvider.getAllNotifications();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            "Error ${response.body['message'] ?? response.statusText}");
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(
          'An Error occurred for delete Notification  $e');
      rethrow;
    }
  }

  getNotificationInfo(MyNotification? myNotification) async {
    try {
      if (myNotification == null) {
        SnackBarHelper.showErrorSnackBar('Please Chose A Image');
        return;
      }

      final response = await service.getItems(
          endpointUrl:
              'notification/track-notification/${myNotification.notificationId}');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(
          response.body,
          (json) => NotificationResult.fromJson(json as Map<String, dynamic>),
        );
        if (apiResponse.success == true) {
          NotificationResult? myNotificationResult = apiResponse.data;
          notificationResult = myNotificationResult;
          log('notification fetch Successfully');
          notifyListeners();
          // SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          return null;
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to Fetch Data');
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

  clearFields() {
    titleCtrl.clear();
    descriptionCtrl.clear();
    imageUrlCtrl.clear();
  }

  updateUI() {
    notifyListeners();
  }
}
