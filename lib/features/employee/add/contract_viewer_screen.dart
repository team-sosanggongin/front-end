import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_path.dart';
import '../../../core/utils/responsive_size.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../employee_provider.dart';

class ContractViewerScreen extends ConsumerWidget {
  final String pdfPath;

  const ContractViewerScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.contractViewerTitle)),
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageSnap: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: rs.pxy(horizontal: 24, vertical: 16),
          child: PrimaryButton(
            text: s.contractViewerConfirmButton,
            onPressed: () async {
              await ref.read(inviteCodeProvider.notifier).generate();
              if (context.mounted) {
                context.push(EmployeePath.inviteCode);
              }
            },
          ),
        ),
      ),
    );
  }
}