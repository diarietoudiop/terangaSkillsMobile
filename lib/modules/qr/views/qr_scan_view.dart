import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/qr_controller.dart';

class QrScanView extends GetView<QrController> {
  const QrScanView({super.key});

  @override
  Widget build(BuildContext context) {
    final scannerController = MobileScannerController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: Get.back,
        ),
        title: Text('Scanner QR Code',
            style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on_rounded, color: Colors.white),
            onPressed: scannerController.toggleTorch,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              controller.reset();
              scannerController.start();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // ─── Camera ──────────────────────────────
          MobileScanner(
            controller: scannerController,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull;
              if (barcode?.rawValue != null) {
                HapticFeedback.mediumImpact();
                controller.onQrDetected(barcode!.rawValue!);
                scannerController.stop();
              }
            },
          ),
          // ─── Overlay Frame ───────────────────────
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // ─── Result Overlay ──────────────────────
          Obx(() {
            if (controller.isVerifying.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            final result = controller.verificationResult.value;
            if (result == null) return const SizedBox.shrink();
            return _ResultSheet(result: result);
          }),
          // ─── Hint ────────────────────────────────
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Pointez vers le QR Code du document',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultSheet extends StatelessWidget {
  final dynamic result;
  const _ResultSheet({required this.result});

  @override
  Widget build(BuildContext context) {
    final isValid = result.isValid == true;
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      builder: (_, scroll) => Container(
        decoration: const BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isValid
                    ? AppColors.success.withOpacity(0.15)
                    : AppColors.error.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isValid
                    ? Icons.verified_rounded
                    : Icons.cancel_rounded,
                color: isValid ? AppColors.success : AppColors.error,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isValid ? 'Document Authentique' : 'Document Non Authentifié',
              style: AppTextStyles.headlineSmall.copyWith(
                color: isValid ? AppColors.success : AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            if (result.document != null) ...[
              Text(result.document.name ?? '',
                  style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Text(
                'Créé le : ${result.document.createdAt.day}/${result.document.createdAt.month}/${result.document.createdAt.year}',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.grey400),
              ),
            ],
            if (result.message != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(result.message,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.grey500)),
              ),
          ],
        ),
      ),
    );
  }
}
