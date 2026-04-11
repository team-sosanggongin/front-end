import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';

class MaintenanceDialog extends StatelessWidget {
  const MaintenanceDialog({
    super.key,
    required this.reason,
    this.startedAt,
    this.endedAt,
  });

  final String reason;
  final String? startedAt;
  final String? endedAt;

  static Future<void> show(
      BuildContext context, {
        required String reason,
        String? startedAt,
        String? endedAt,
      }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => MaintenanceDialog(
        reason: reason,
        startedAt: startedAt,
        endedAt: endedAt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final l10n = S.of(context);

    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rs.w(16)),
        ),
        backgroundColor: AppColors.white,
        child: Padding(
          padding: EdgeInsets.all(rs.w(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.maintenanceDialogTitle, style: AppTextStyles.titleMedium),
              SizedBox(height: rs.h(12)),
              Text(reason, style: AppTextStyles.body),
              if (startedAt != null || endedAt != null) ...[
                SizedBox(height: rs.h(16)),
                _TimeRow(label: l10n.maintenanceStartLabel, value: startedAt),
                SizedBox(height: rs.h(4)),
                _TimeRow(label: l10n.maintenanceEndLabel, value: endedAt),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({required this.label, this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    if (value == null) return const SizedBox.shrink();

    return Row(
      children: [
        Text(label, style: AppTextStyles.caption),
        SizedBox(width: rs.w(8)),
        Text(
          value!,
          style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}