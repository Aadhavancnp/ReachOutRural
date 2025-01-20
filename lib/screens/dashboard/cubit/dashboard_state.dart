part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}


class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Doctor> doctors;
  final List<Hospital> hospitals;

  const DashboardLoaded({required this.doctors, required this.hospitals});

  DashboardLoaded copyWith({List<Doctor>? doctors, List<Hospital>? hospitals}) {
    return DashboardLoaded(
      doctors: doctors ?? this.doctors,
      hospitals: hospitals ?? this.hospitals,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});
}
