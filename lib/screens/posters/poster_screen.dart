import 'package:e_admin/utility/extensions.dart';

import 'components/add_poster_form.dart';
import 'components/poster_header.dart';
import 'components/poster_list_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';

class PosterScreen extends StatelessWidget {
  const PosterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const PosterHeader(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              "My Posters",
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
                              showAddPosterForm(context, null);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add New"),
                          ),
                          const Gap(20),
                          IconButton(
                              onPressed: () {
                                context.dataProvider
                                    .getAllPoster(showSnack: true);
                              },
                              icon: const Icon(Icons.refresh)),
                        ],
                      ),
                      const Gap(defaultPadding),
                      const PosterListSection(),
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
