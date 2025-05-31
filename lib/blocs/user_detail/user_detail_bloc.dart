import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti/blocs/user_detail/user_detail_event.dart';
import 'package:nineti/blocs/user_detail/user_detail_state.dart';
import 'package:nineti/models/post.dart';
import 'package:nineti/repositories/user_repository.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final UserRepository repo;
  final List<Post> _localPosts = [];
  UserDetailBloc({required this.repo}) : super(UserDetailInitial()) {
    on<FetchUserDetail>(_onFetch);
    on<AddLocalPost>(_onAddLocal);
  }
  Future<void> _onFetch(FetchUserDetail e, Emitter emit) async {
    emit(UserDetailLoading());
    try {
      final posts = await repo.fetchPosts(e.userId);
      final todos = await repo.fetchTodos(e.userId);
      emit(UserDetailSuccess([..._localPosts, ...posts], todos));
    } catch (e) {
      emit(UserDetailFailure(e.toString()));
    }
  }

  void _onAddLocal(AddLocalPost e, Emitter emit) {
    if (state is UserDetailSuccess) {
      final curr = state as UserDetailSuccess;
      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch,
        title: e.title,
        body: e.body,
      );
      _localPosts.insert(0, newPost);
      emit(
        UserDetailSuccess([
          ..._localPosts,
          ...curr.posts.where((p) => !_localPosts.contains(p)),
        ], curr.todos),
      );
    }
  }
}
