import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';
import '../consent/consent_provider.dart';

class AccountVerificationScreen extends ConsumerStatefulWidget {
  const AccountVerificationScreen({super.key});

  @override
  ConsumerState<AccountVerificationScreen> createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState
    extends ConsumerState<AccountVerificationScreen> {
  String? _selectedBank;
  bool _isDropdownOpen = false;
  final _accountController = TextEditingController();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool get _canSubmit =>
      _selectedBank != null && _accountController.text.isNotEmpty;

  @override
  void dispose() {
    _removeOverlay();
    _accountController.dispose();
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

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildContent(banks)),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<String> banks) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('계좌 정보를 입력해 주세요', style: AppTextStyles.heading),
          const SizedBox(height: 8),
          const Text('급여 수령에 사용될 계좌를 등록해 주세요', style: AppTextStyles.subtitle),
          const SizedBox(height: 32),
          _buildBankDropdown(banks),
          const SizedBox(height: 20),
          _buildAccountNumberField(),
          const SizedBox(height: 20),
          _buildNotice(),
        ],
      ),
    );
  }

  Widget _buildBankDropdown(List<String> banks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('은행', style: AppTextStyles.label),
        const SizedBox(height: 8),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: () => _toggleDropdown(banks),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isDropdownOpen ? AppColors.dark : AppColors.borderGray,
                  width: _isDropdownOpen ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedBank ?? '은행을 선택하세요',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('계좌번호', style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextField(
          controller: _accountController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyles.body,
          onChanged: (_) => setState(() {}),
          decoration: AppInputDecorations.outlined(hintText: '\'-\' 없이 숫자만 입력'),
        ),
      ],
    );
  }

  Widget _buildNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('안내사항', style: AppTextStyles.label),
          const SizedBox(height: 6),
          Text(
            '입력하신 계좌는 급여 수령 계좌로만 사용되며, 본인 명의의 계좌만 등록 가능합니다.',
            style: AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: PrimaryButton(
        text: '등록하기',
        enabled: _canSubmit,
        onPressed: _canSubmit ? () => context.go('/home') : null,
      ),
    );
  }

  OverlayEntry _buildOverlayEntry(List<String> banks) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 48,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 56),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderGray),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : const Border(
                          bottom: BorderSide(color: AppColors.borderGray),
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
      ),
    );
  }
}