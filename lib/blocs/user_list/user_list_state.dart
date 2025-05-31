import 'package:equatable/equatable.dart';
import '../../models/user.dart';

abstract class UserListState extends Equatable {
  const UserListState();
  @override
  List<Object?> get props => [];
}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListSuccess extends UserListState {
  final List<User> users;
  final bool hasReachedMax;
  const UserListSuccess(this.users, this.hasReachedMax);
  @override
  List<Object?> get props => [users, hasReachedMax];

  String? get query => null;
}

class UserListFailure extends UserListState {
  final String error;
  const UserListFailure(this.error);
  @override
  List<Object?> get props => [error];
}
