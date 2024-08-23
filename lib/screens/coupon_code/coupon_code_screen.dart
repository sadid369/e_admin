import 'package:e_admin/utility/extensions.dart';
import 'components/coupon_code_header.dart';
import 'components/coupon_list_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import 'components/add_coupon_form.dart';

class CouponCodeScreen extends StatelessWidget {
  const CouponCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const CouponCodeHeader(),
            const Gap(defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "My Sub Categories",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding,
                              ),
                            ),
                            onPressed: () {
                              showAddCouponForm(context, null);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add New"),
                          ),
                          const Gap(20),
                          IconButton(
                              onPressed: () {
                                context.dataProvider
                                    .getAllCoupons(showSnack: true);
                              },
                              icon: const Icon(Icons.refresh)),
                        ],
                      ),
                      const Gap(defaultPadding),
                      const CouponListSection(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
