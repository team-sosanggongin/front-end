import 'package:flutter_riverpod/flutter_riverpod.dart';

//은행 목록
class BankListNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    // TODO: API 연결 시 fetch('/banks') 로 교체
    return const [
      'KB국민은행',
      '신한은행',
      '우리은행',
      '하나은행',
      'NH농협은행',
      'IBK기업은행',
    ];
  }
}

final bankListProvider = NotifierProvider<BankListNotifier, List<String>>(
  BankListNotifier.new,
);
