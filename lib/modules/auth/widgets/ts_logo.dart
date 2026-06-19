import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TsLogo extends StatelessWidget {
  final double size;
  const TsLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.account_balance_rounded,
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'CIVILINK',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ).createShader(const Rect.fromLTWH(0, 0, 200, 30)),
          ),
        ),
        Text(
          'Gouvernance Numérique',
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500),
        ),
      ],
    );
  }
}
