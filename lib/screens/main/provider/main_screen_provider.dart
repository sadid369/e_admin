import '../../brands/brand_screen.dart';
import '../../category/category_screen.dart';
import '../../coupon_code/coupon_code_screen.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../notification/notification_screen.dart';
import '../../order/order_screen.dart';
import '../../posters/poster_screen.dart';
import '../../variants/variants_screen.dart';
import '../../variants_type/variants_type_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../sub_category/sub_category_screen.dart';

class MainScreenProvider extends ChangeNotifier {
  Widget selectedScreen = const DashboardScreen();

  navigateToScreen(String screenName) {
    switch (screenName) {
      case 'Dashboard':
        selectedScreen = const DashboardScreen();
        break; // Break statement needed here
      case 'Category':
        selectedScreen = const CategoryScreen();
        break;
      case 'SubCategory':
        selectedScreen = const SubCategoryScreen();
        break;
      case 'Brands':
        selectedScreen = const BrandScreen();
        break;
      case 'VariantType':
        selectedScreen = const VariantsTypeScreen();
        break;
      case 'Variants':
        selectedScreen = const VariantsScreen();
        break;
      case 'Coupon':
        selectedScreen = const CouponCodeScreen();
        break;
      case 'Poster':
        selectedScreen = const PosterScreen();
        break;
      case 'Order':
        selectedScreen = const OrderScreen();
        break;
      case 'Notifications':
        selectedScreen = const NotificationScreen();
        break;
      default:
        selectedScreen = const DashboardScreen();
    }
    notifyListeners();
  }
}
