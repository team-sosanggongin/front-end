import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import 'primary_button.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({
    super.key,
    required this.latestVersion,
    required this.isForced,
    this.reason,
    required this.storeUrl,
  });

  final String latestVersion;
  final bool isForced;
  final String? reason;
  final String storeUrl;

  static Future<void> show(
      BuildContext context, {
        required String latestVersion,
        required bool isForced,
        String? reason,
        required String storeUrl,
      }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => UpdateDialog(
        latestVersion: latestVersion,
        isForced: isForced,
        reason: reason,
        storeUrl: storeUrl,
      ),
    );
  }

  Future<void> _openStore() async {
    final uri = Uri.parse(storeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final l10n = S.of(context);

    return PopScope(
      canPop: !isForced,
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
              Text(
                isForced
                    ? l10n.forceUpdateDialogTitle
                    : l10n.optionalUpdateDialogTitle,
                style: AppTextStyles.titleMedium,
              ),
              SizedBox(height: rs.h(12)),
              Text(
                reason ??
                    (isForced
                        ? l10n.forceUpdateDialogMessage
                        : l10n.optionalUpdateDialogMessage),
                style: AppTextStyles.body,
              ),
              SizedBox(height: rs.h(8)),
              Text(
                l10n.updateDialogLatestVersion(latestVersion),
                style: AppTextStyles.caption,
              ),
              SizedBox(height: rs.h(24)),
              PrimaryButton(
                text: l10n.updateButton,
                onPressed: _openStore,
              ),
              if (!isForced) ...[
                SizedBox(height: rs.h(12)),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(l10n.skipButton, style: AppTextStyles.link),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}