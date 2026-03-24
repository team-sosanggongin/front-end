class Notice {
  final String id;
  final String title;
  final String description;
  final String date;
  final bool isNew;

  const Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.isNew = false,
  });
}

final mockNotices = [
  const Notice(
    id: '1',
    title: '정기 휴무일 안내',
    description: '매주 월요일은 정기 휴무일입니다.',
    date: '2026.03.05',
    isNew: true,
  ),
  const Notice(
    id: '2',
    title: '정기 휴무일 안내',
    description: '매주 월요일은 정기 휴무일입니다.',
    date: '2026.03.05',
  ),
];
