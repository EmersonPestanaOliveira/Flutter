import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models.dart';
import '../../data/repository.dart';

class DailyState extends Equatable {
  final DateTime date;
  final bool loading;
  final List<DailyTaskView> tasks;
  final int totalXp;

  const DailyState({
    required this.date,
    this.loading = false,
    this.tasks = const [],
    this.totalXp = 0,
  });

  DailyState copyWith({
    DateTime? date,
    bool? loading,
    List<DailyTaskView>? tasks,
    int? totalXp,
  }) => DailyState(
    date: date ?? this.date,
    loading: loading ?? this.loading,
    tasks: tasks ?? this.tasks,
    totalXp: totalXp ?? this.totalXp,
  );

  @override
  List<Object?> get props => [date, loading, tasks, totalXp];
}

class DailyCubit extends Cubit<DailyState> {
  DailyCubit(this._repo) : super(DailyState(date: DateTime.now()));
  final ChecklistRepository _repo;

  Future<void> load(DateTime date) async {
    emit(state.copyWith(loading: true, date: date));
    await _repo.ensureDailyFor(date);
    final list = await _repo.getDaily(date);
    final total = await _repo.getTotalXp(ymd(date));
    emit(state.copyWith(loading: false, tasks: list, totalXp: total));
  }

  Future<void> prevDay() => load(state.date.subtract(const Duration(days: 1)));
  Future<void> nextDay() => load(state.date.add(const Duration(days: 1)));

  Future<void> updateBool(int entryId, bool value) async {
    await _repo.updateBool(entryId, value);
    await load(state.date);
  }

  Future<void> updateNumber(int entryId, double? value) async {
    await _repo.updateNumber(entryId, value);
    await load(state.date);
  }

  Future<void> updateTime(int entryId, String? hhmm) async {
    await _repo.updateTime(entryId, hhmm);
    await load(state.date);
  }
}
