import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_path.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_size.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/contract_method_card.dart';

class ContractMethodScreen extends StatelessWidget {
  const ContractMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.contractMethodTitle)),
      body: Padding(
        padding: rs.pxy(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.contractMethodHeading, style: AppTextStyles.titleMedium),
            SizedBox(height: rs.h(24)),
            // PDF 직접 업로드 (실제 플로우)
            ContractMethodCard(
              icon: Icons.upload_file_outlined,
              label: s.contractMethodDirectLabel,
              description: s.contractMethodDirectDesc,
              onTap: () => context.push(EmployeePath.contractUpload),
            ),
            SizedBox(height: rs.h(12)),
            // 템플릿 불러오기 (비활성)
            ContractMethodCard(
              icon: Icons.description_outlined,
              label: s.contractMethodTemplateLabel,
              description: s.contractMethodTemplateDesc,
              isDisabled: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}