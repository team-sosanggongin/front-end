import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/tag_badge.dart';
import '../../core/theme/app_theme.dart';
import '../my/user_provider.dart';

class AccountListScreen extends ConsumerWidget {
  const AccountListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountListProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildList(context, ref, accounts)),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, WidgetRef ref, List<AccountModel> accounts) {
    if (accounts.isEmpty) {
      return Center(
        child: Text(
          '등록된 계좌가 없습니다.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: accounts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _AccountCard(
        account: accounts[index],
        onDelete: () => _showDeleteDialog(context, ref, accounts[index].id),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: OutlinedButton(
        // 마이페이지에서 계좌 추가 → 급여동의부터 시작 (나중에 하기 버튼 숨김)
        onPressed: () => context.push('/salary-consent', extra: true),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: AppColors.dark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          '+ 계좌 추가',
          style:
          AppTextStyles.buttonText.copyWith(color: AppColors.darkBackground),
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, String accountId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계좌 삭제', style: AppTextStyles.titleMedium),
        content: const Text('해당 계좌를 삭제하시겠습니까?', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소',
                style: AppTextStyles.label
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              ref.read(accountListProvider.notifier).removeAccount(accountId);
              Navigator.pop(context);
            },
            child: Text('삭제',
                style:
                AppTextStyles.label.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final AccountModel account;
  final VoidCallback onDelete;

  const _AccountCard({required this.account, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TagBadge(label: account.type),
          const SizedBox(height: 12),
          _buildInfoRow('은행', account.bankName,
              valueStyle: AppTextStyles.titleMedium),
          const SizedBox(height: 10),
          _buildInfoRow('계좌번호', account.accountNumber),
          const SizedBox(height: 10),
          _buildInfoRow('예금주', account.accountHolder),
          const SizedBox(height: 16),
          _buildActions(context),  // context 전달
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? valueStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 2),
        Text(value, style: valueStyle ?? AppTextStyles.body),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildChangeButton(context)),
        const SizedBox(width: 8),
        Expanded(child: _buildDeleteButton()),
      ],
    );
  }

  Widget _buildChangeButton(BuildContext context) {
    return OutlinedButton(
      // 변경도 급여동의부터 시작 (fromMyPage: true)
      onPressed: () => context.push('/salary-consent', extra: true),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderGray),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Text('변경',
          style:
          AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
    );
  }

  Widget _buildDeleteButton() {
    return OutlinedButton(
      onPressed: onDelete,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.error),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Text('삭제',
          style: AppTextStyles.label.copyWith(color: AppColors.error)),
    );
  }
}