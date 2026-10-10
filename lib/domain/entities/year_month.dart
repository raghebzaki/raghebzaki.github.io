import 'package:equatable/equatable.dart';

/// A calendar month without a day component (const-friendly alternative to
/// `DateTime`).
class YearMonth extends Equatable implements Comparable<YearMonth> {
  const YearMonth(this.year, this.month)
    : assert(month >= 1 && month <= 12, 'month must be within 1..12');

  final int year;
  final int month;

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  int compareTo(YearMonth other) {
    final byYear = year.compareTo(other.year);
    return byYear != 0 ? byYear : month.compareTo(other.month);
  }

  bool isAfter(YearMonth other) => compareTo(other) > 0;

  /// e.g. `Dec 2024`.
  String get label => '${_months[month - 1]} $year';

  @override
  List<Object?> get props => [year, month];
}
