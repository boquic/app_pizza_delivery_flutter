import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';

/// Shimmer effect para el grid de pizzas mientras carga
class PizzaGridShimmer extends StatelessWidget {
  final int itemCount;

  const PizzaGridShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.surfaceVariant,
          highlightColor: Colors.white,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: AppColors.surfaceVariant,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: AppColors.surfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 12,
                          color: AppColors.surfaceVariant,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 100,
                          height: 12,
                          color: AppColors.surfaceVariant,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 60,
                              height: 20,
                              color: AppColors.surfaceVariant,
                            ),
                            Container(
                              width: 80,
                              height: 12,
                              color: AppColors.surfaceVariant,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
