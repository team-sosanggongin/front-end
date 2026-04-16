import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/primary_button.dart';
import '../../common/widgets/tag_badge.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import '../consent/consent_provider.dart';
import '../my/user_provider.dart';
import 'account_list_provider.dart';

class AccountListScreen extends ConsumerWidget {
  const AccountListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountListProvider);

    return Scaffold(
      body: SafeArea(
        child: switch (state) {
          AccountListStateLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          AccountListStateError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, style: AppTextStyles.body),
                TextButton(
                  onPressed: () =>
                      ref.read(accountListProvider.notifier).fetch(),
                  child: Text(S.of(context).retryButton),
                ),
              ],
            ),
          ),
          AccountListStateLoaded(:final accounts) => Column(
            children: [
              Expanded(child: _buildList(context, ref, accounts)),
              _buildAddButton(context),
            ],
          ),
        },
      ),
    );
  }

  Widget _buildList(
      BuildContext context, WidgetRef ref, List<AccountModel> accounts) {
    if (accounts.isEmpty) {
      return Center(
        child: Text(
          S.of(context).noRegisteredAccounts,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    final rs = ResponsiveSize.of(context);

    return ListView.separated(
      padding: rs.pxy(horizontal: 24, vertical: 24),
      itemCount: accounts.length,
      separatorBuilder: (_, __) => SizedBox(height: rs.h(16)),
      itemBuilder: (context, index) => _AccountCard(
        account: accounts[index],
        onDelete: () =>
            _showDeleteDialog(context, ref, accounts[index].id),
        onEdit: () =>
            _showEditDialog(context, ref, accounts[index]),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return Padding(
      padding: rs.fromLTRB(24, 0, 24, 24),
      child: OutlinedButton(
        onPressed: () => context.push(ConsentPath.salary, extra: true),
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, rs.h(56)),
          side: const BorderSide(color: AppColors.dark),
          shape: RoundedRectangleBorder(
            borderRadius: rs.radius(12),
          ),
        ),
        child: Text(
          S.of(context).addAccountButton,
          style: AppTextStyles.buttonText
              .copyWith(color: AppColors.darkBackground),
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, WidgetRef ref, String accountId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteAccountTitle,
            style: AppTextStyles.titleMedium),
        content: Text(S.of(context).deleteAccountConfirmation,
            style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancelButton,
                style: AppTextStyles.label
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(accountListProvider.notifier)
                  .deleteAccount(accountId);
              Navigator.pop(context);
            },
            child: Text(S.of(context).deleteButton,
                style:
                AppTextStyles.label.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, AccountModel account) {
    final bankController =
    TextEditingController(text: account.bankName);
    final numberController =
    TextEditingController(text: account.accountNumber);
    final aliasController =
    TextEditingController(text: account.accountAlias);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).changeButton,
            style: AppTextStyles.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bankController,
              decoration: AppInputDecorations.outlined(
                  hintText: S.of(context).bankLabel),
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: numberController,
              decoration: AppInputDecorations.outlined(
                  hintText: S.of(context).accountNumberLabel),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: aliasController,
              decoration: AppInputDecorations.outlined(
                  hintText: S.of(context).accountAliasLabel),
              style: AppTextStyles.body,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancelButton,
                style: AppTextStyles.label
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              ref.read(accountListProvider.notifier).updateAccount(
                accountId: account.id,
                bankName: bankController.text,
                accountNumber: numberController.text,
                accountAlias: aliasController.text,
              );
              Navigator.pop(context);
            },
            child: Text(S.of(context).confirmButton,
                style: AppTextStyles.label
                    .copyWith(color: AppColors.dark)),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final AccountModel account;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _AccountCard({
    required this.account,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return Container(
      padding: rs.pxy(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: rs.radius(16),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TagBadge(label: account.accountAlias),
          SizedBox(height: rs.h(12)),
          _buildInfoRow(context, S.of(context).bankLabel, account.bankName,
              valueStyle: AppTextStyles.titleMedium),
          SizedBox(height: rs.h(10)),
          _buildInfoRow(context, S.of(context).accountNumberLabel,
              account.accountNumber),
          SizedBox(height: rs.h(16)),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      {TextStyle? valueStyle}) {
    final rs = ResponsiveSize.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        SizedBox(height: rs.h(2)),
        Text(value, style: valueStyle ?? AppTextStyles.body),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return Row(
      children: [
        Expanded(child: _buildEditButton(context)),
        SizedBox(width: rs.w(8)),
        Expanded(child: _buildDeleteButton(context)),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return OutlinedButton(
      onPressed: onEdit,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderGray),
        shape: RoundedRectangleBorder(borderRadius: rs.radius(8)),
        padding: rs.py(10),
      ),
      child: Text(S.of(context).changeButton,
          style: AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return OutlinedButton(
      onPressed: onDelete,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.error),
        shape: RoundedRectangleBorder(borderRadius: rs.radius(8)),
        padding: rs.py(10),
      ),
      child: Text(S.of(context).deleteButton,
          style: AppTextStyles.label.copyWith(color: AppColors.error)),
    );
  }
}