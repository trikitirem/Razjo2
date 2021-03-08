part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class LoadData extends DashboardEvent {
  LoadData({@required this.user});
  final User user;

  @override
  List<Object> get props => [user];
}

class GoToHome extends DashboardEvent {
  @override
  List<Object> get props => [];
}

class GoToNotes extends DashboardEvent {
  @override
  List<Object> get props => [];
}

class GoToAppointments extends DashboardEvent {
  @override
  List<Object> get props => [];
}

class GoToPatients extends DashboardEvent {
  @override
  List<Object> get props => [];
}

class GoToSettings extends DashboardEvent {
  @override
  List<Object> get props => [];
}