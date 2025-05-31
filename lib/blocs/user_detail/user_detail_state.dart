import 'package:equatable/equatable.dart';
import '../../models/post.dart';
import '../../models/todo.dart';

abstract class UserDetailState extends Equatable {
  const UserDetailState();
  @override
  List<Object?> get props => [];
}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailSuccess extends UserDetailState {
  final List<Post> posts;
  final List<Todo> todos;
  const UserDetailSuccess(this.posts, this.todos);
  @override
  List<Object?> get props => [posts, todos];
}

class UserDetailFailure extends UserDetailState {
  final String error;
  const UserDetailFailure(this.error);
  @override
  List<Object?> get props => [error];
}
