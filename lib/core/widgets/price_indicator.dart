import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

/// Widget para mostrar precios de forma consistente
class PriceIndicator extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final TextStyle? style;
  final bool showCurrency;
  final bool isLarge;

  const PriceIndicator({
    super.key,
    required this.price,
    this.originalPrice,
    this.style,
    this.showCurrency = true,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      symbol: showCurrency ? '\$' : '',
      decimalDigits: 2,
    );

    final defaultStyle = isLarge
        ? Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            )
        : Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          formatter.format(price),
          style: style ?? defaultStyle,
        ),
        if (originalPrice != null && originalPrice! > price) ...[
          const SizedBox(width: 8),
          Text(
            formatter.format(originalPrice),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.lineThrough,
                ),
          ),
        ],
      ],
    );
  }
}
