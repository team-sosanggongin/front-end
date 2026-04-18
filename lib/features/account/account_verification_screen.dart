import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/primary_button.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import '../consent/consent_provider.dart';
import 'account_provider.dart';

class AccountVerificationScreen extends ConsumerStatefulWidget {
  final bool fromMyPage;

  const AccountVerificationScreen({
    super.key,
    this.fromMyPage = false,
  });

  @override
  ConsumerState<AccountVerificationScreen> createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState
    extends ConsumerState<AccountVerificationScreen> {
  String? _selectedBank;
  bool _isDropdownOpen = false;
  final _accountController = TextEditingController();
  final _aliasController = TextEditingController();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool get _canSubmit =>
      _selectedBank != null &&
          _accountController.text.isNotEmpty &&
          _aliasController.text.isNotEmpty;

  @override
  void dispose() {
    _removeOverlay();
    _accountController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  void _toggleDropdown(List<String> banks) {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showOverlay(banks);
    }
    setState(() => _isDropdownOpen = !_isDropdownOpen);
  }

  void _showOverlay(List<String> banks) {
    _overlayEntry = _buildOverlayEntry(banks);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectBank(String bank) {
    setState(() {
      _selectedBank = bank;
      _isDropdownOpen = false;
    });
    _removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final banks = ref.watch(bankListProvider);
    final accountState = ref.watch(accountProvider);

    ref.listen<AccountState>(accountProvider, (_, next) {
      switch (next) {
        case AccountStateSuccess():
          if (widget.fromMyPage) {
            context.pop(); // 마이페이지에서 온 경우 그냥 뒤로
            context.pop(); // salary_consent까지 pop
          } else {
            context.go(HomePath.root); // 초기 플로우는 go 유지
          }
        case AccountStateError(:final message):
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          ref.read(accountProvider.notifier).resetState();
        case AccountStateIdle():
        case AccountStateLoading():
          break;
      }
    });

    final isLoading = accountState is AccountStateLoading;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildContent(banks)),
            _buildBottomButton(isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<String> banks) {
    final rs = ResponsiveSize.of(context);
    final l = S.of(context);

    return SingleChildScrollView(
      padding: rs.px(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: rs.h(8)),
          Text(l.enterAccountInfoTitle, style: AppTextStyles.heading),
          SizedBox(height: rs.h(8)),
          Text(l.registerAccountSubtitle, style: AppTextStyles.subtitle),
          SizedBox(height: rs.h(32)),
          _buildBankDropdown(banks),
          SizedBox(height: rs.h(20)),
          _buildAccountNumberField(),
          SizedBox(height: rs.h(20)),
          _buildAliasField(),
          SizedBox(height: rs.h(20)),
          _buildNotice(),
        ],
      ),
    );
  }

  Widget _buildBankDropdown(List<String> banks) {
    final rs = ResponsiveSize.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).bankLabel, style: AppTextStyles.label),
        SizedBox(height: rs.h(8)),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: () => _toggleDropdown(banks),
            child: Container(
              height: rs.h(52),
              padding: rs.px(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: rs.radius(10),
                border: Border.all(
                  color: _isDropdownOpen ? AppColors.dark : AppColors.borderGray,
                  width: _isDropdownOpen ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedBank ?? S.of(context).selectBankHint,
                      style: AppTextStyles.body.copyWith(
                        color: _selectedBank != null
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Icon(
                    _isDropdownOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountNumberField() {
    final rs = ResponsiveSize.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).accountNumberLabel, style: AppTextStyles.label),
        SizedBox(height: rs.h(8)),
        TextField(
          controller: _accountController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyles.body,
          onChanged: (_) => setState(() {}),
          decoration: AppInputDecorations.outlined(
              hintText: S.of(context).accountNumberHint),
        ),
      ],
    );
  }

  Widget _buildAliasField() {
    final rs = ResponsiveSize.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).accountAliasLabel, style: AppTextStyles.label),
        SizedBox(height: rs.h(8)),
        TextField(
          controller: _aliasController,
          style: AppTextStyles.body,
          onChanged: (_) => setState(() {}),
          decoration: AppInputDecorations.outlined(
              hintText: S.of(context).accountAliasHint),
        ),
      ],
    );
  }

  Widget _buildNotice() {
    final rs = ResponsiveSize.of(context);
    return Container(
      width: double.infinity,
      padding: rs.pxy(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: rs.radius(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).noticeLabel, style: AppTextStyles.label),
          SizedBox(height: rs.h(6)),
          Text(S.of(context).accountRegistrationNotice,
              style: AppTextStyles.subtitle),
        ],
      ),
    );
  }

  Widget _buildBottomButton(bool isLoading) {
    final rs = ResponsiveSize.of(context);
    return Padding(
      padding: rs.fromLTRB(24, 0, 24, 24),
      child: PrimaryButton(
        text: S.of(context).registerButton,
        enabled: _canSubmit && !isLoading,
        onPressed: _canSubmit && !isLoading
            ? () => ref.read(accountProvider.notifier).registerAccount(
          bankName: _selectedBank!,
          accountNumber: _accountController.text,
          accountAlias: _aliasController.text,
        )
            : null,
      ),
    );
  }

  OverlayEntry _buildOverlayEntry(List<String> banks) {
    return OverlayEntry(
      builder: (context) {
        final rs = ResponsiveSize.of(context);
        return Positioned(
          width: rs.screenWidth - rs.w(48),
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, rs.h(56)),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: rs.radius(10),
                  border: Border.all(color: AppColors.borderGray),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: rs.w(12),
                      offset: Offset(0, rs.h(4)),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: banks.map((bank) {
                    final isLast = bank == banks.last;
                    return InkWell(
                      onTap: () => _selectBank(bank),
                      child: Container(
                        width: double.infinity,
                        padding: rs.pxy(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: isLast
                              ? null
                              : const Border(
                            bottom:
                            BorderSide(color: AppColors.borderGray),
                          ),
                        ),
                        child: Text(bank, style: AppTextStyles.body),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}