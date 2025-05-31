import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';
import '../../repositories/user_repository.dart';
import '../../core/constants.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final UserRepository repo;
  int skip = 0;
  bool isFetching = false;
  String? currentQuery;

  UserListBloc({required this.repo}) : super(UserListInitial()) {
    on<FetchUsers>(_onFetch);
    on<SearchUsers>(_onSearch);
    on<LoadMoreUsers>(_onLoadMore);
  }

  Future<void> _onFetch(FetchUsers event, Emitter emit) async {
    emit(UserListLoading());
    skip = 0;
    currentQuery = null;
    try {
      final users = await repo.fetchUsers(limit: pageLimit, skip: skip);
      emit(UserListSuccess(users, users.length < pageLimit));
      skip += users.length;
    } catch (e) {
      emit(UserListFailure(e.toString()));
    }
  }

  Future<void> _onSearch(SearchUsers event, Emitter emit) async {
    emit(UserListLoading());
    skip = 0;
    currentQuery = event.query;
    try {
      final users = await repo.fetchUsers(
        limit: pageLimit,
        skip: skip,
        search: event.query,
      );
      emit(UserListSuccess(users, users.length < pageLimit));
      skip += users.length;
    } catch (e) {
      emit(UserListFailure(e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMoreUsers event, Emitter emit) async {
    if (state is UserListSuccess && !isFetching) {
      final current = state as UserListSuccess;
      if (current.hasReachedMax) return;
      isFetching = true;
      try {
        final more = await repo.fetchUsers(
          limit: pageLimit,
          skip: skip,
          search: currentQuery,
        );
        final all = List.of(current.users)..addAll(more);
        emit(UserListSuccess(all, more.length < pageLimit));
        skip += more.length;
      } catch (e) {
        emit(UserListFailure(e.toString()));
      }
      isFetching = false;
    }
  }
}
