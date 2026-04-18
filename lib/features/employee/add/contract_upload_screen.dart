import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/router/route_path.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_size.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';

final _selectedFileProvider =
StateProvider<PlatformFile?>((ref) => null);

class ContractUploadScreen extends ConsumerWidget {
  const ContractUploadScreen({super.key});

  Future<void> _pickFile(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      ref.read(_selectedFileProvider.notifier).state = result.files.first;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);
    final selectedFile = ref.watch(_selectedFileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.contractUploadTitle)),
      body: Padding(
        padding: rs.pxy(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.contractUploadHeading, style: AppTextStyles.titleMedium),
            SizedBox(height: rs.h(8)),
            Text(s.contractUploadSubtitle, style: AppTextStyles.caption),
            SizedBox(height: rs.h(32)),
            // 업로드
            GestureDetector(
              onTap: () => _pickFile(ref),
              child: Container(
                width: double.infinity,
                height: rs.h(180),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: rs.radius(12),
                  border: Border.all(
                    color: selectedFile != null
                        ? AppColors.darkBackground
                        : AppColors.borderGray,
                    width: 1.5,
                  ),
                ),
                child: selectedFile == null
                    ? _buildUploadPlaceholder(context, rs, s)
                    : _buildSelectedFile(context, rs, selectedFile),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: rs.pxy(horizontal: 24, vertical: 16),
          child: PrimaryButton(
            text: s.contractUploadNextButton,
            enabled: selectedFile != null,
            onPressed: () => context.push(
              EmployeePath.contractViewer,
              extra: selectedFile?.path ?? '',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder(
      BuildContext context, ResponsiveSize rs, S s) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.upload_file_outlined,
            size: rs.w(40), color: AppColors.textSecondary),
        SizedBox(height: rs.h(12)),
        Text(s.contractUploadButton,
            style: AppTextStyles.label
                .copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSelectedFile(
      BuildContext context, ResponsiveSize rs, PlatformFile file) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.picture_as_pdf_outlined,
            size: rs.w(32), color: AppColors.darkBackground),
        SizedBox(width: rs.w(12)),
        Flexible(
          child: Text(
            file.name,
            style: AppTextStyles.label,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}