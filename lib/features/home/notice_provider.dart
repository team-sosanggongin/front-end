import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_provider.dart';
import '../../utils/env_config.dart';

// 모델

class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.isPinned,
    required this.viewCount,
    required this.createdAt,
    this.startsAt,
    this.endsAt,
  });

  final int id;
  final String title;
  final String content;
  final String authorName;
  final bool isPinned;
  final int viewCount;
  final String createdAt;
  final String? startsAt;
  final String? endsAt;



  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    id: json['id'] as int,
    title: json['title'] as String,
    content: json['content'] as String,
    authorName: json['authorName'] as String,
    isPinned: json['isPinned'] as bool? ?? false,
    viewCount: json['viewCount'] as int? ?? 0,
    createdAt: json['createdAt'] as String,
    startsAt: json['startsAt'] as String?,
    endsAt: json['endsAt'] as String?,
  );
}

// API

abstract class _NoticeApiPath {
  static const list = 'api/v1/notices';
  static String detail(int id) => 'api/v1/notices/$id';
}

// 공지 목록 Provider

final noticeListProvider =
StateNotifierProvider<NoticeListNotifier, AsyncValue<List<Notice>>>((ref) {
  return NoticeListNotifier(ref.read(dioProvider));
});

class NoticeListNotifier extends StateNotifier<AsyncValue<List<Notice>>> {
  NoticeListNotifier(this._dio) : super(const AsyncLoading()) {
    fetch();
  }

  final Dio _dio;
  int _page = 0;
  bool _hasMore = true;
  final List<Notice> _notices = [];

  Future<void> fetch({bool refresh = false}) async {
    if (refresh) {
      _page = 0;
      _hasMore = true;
      _notices.clear();
    }

    if (!_hasMore) return;
    state = const AsyncLoading();

    try {
      // GET /api/v1/notices
      final res = await _dio.get(
        _NoticeApiPath.list,
        queryParameters: {'page': _page, 'size': 10},
      );
      final data = res.data as Map<String, dynamic>;
      final page = data['publicNotices'] as Map<String, dynamic>;
      final content = (page['content'] as List)
          .map((e) => Notice.fromJson(e as Map<String, dynamic>))
          .toList();

      _notices.addAll(content);
      _page++;
      _hasMore = page['last'] != true;
      state = AsyncData(List.from(_notices));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

}

// 공지 상세 Provider

final noticeDetailProvider = StateNotifierProvider.family<
    NoticeDetailNotifier, AsyncValue<Notice?>, int>((ref, id) {
  return NoticeDetailNotifier(ref.read(dioProvider), id);
});

class NoticeDetailNotifier extends StateNotifier<AsyncValue<Notice?>> {
  NoticeDetailNotifier(this._dio, this._id) : super(const AsyncLoading()) {
    fetch();
  }

  final Dio _dio;
  final int _id;

  Future<void> fetch() async {
    state = const AsyncLoading();
    try {
      // GET /api/v1/notices/{id}
      final res = await _dio.get(_NoticeApiPath.detail(_id));
      final data = res.data as Map<String, dynamic>;
      state = AsyncData(
          Notice.fromJson(data['publicNotice'] as Map<String, dynamic>));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}