import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti/blocs/user_detail/user_detail_bloc.dart';
import 'package:nineti/blocs/user_detail/user_detail_event.dart';
import 'package:nineti/blocs/user_detail/user_detail_state.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../widgets/post_tile.dart';
import '../widgets/todo_tile.dart';
import 'create_post_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;
  const UserDetailScreen({required this.user, super.key});
  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen>
    with SingleTickerProviderStateMixin {
  late final UserDetailBloc _bloc;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _bloc = UserDetailBloc(repo: UserRepository())
      ..add(FetchUserDetail(widget.user.id));
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.firstName} ${widget.user.lastName}'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Posts'),
            Tab(text: 'Todos'),
          ],
        ),
      ),
      body: BlocBuilder<UserDetailBloc, UserDetailState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is UserDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserDetailSuccess) {
            return TabBarView(
              controller: _tabController,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push<PostData?>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CreatePostScreen(),
                              ),
                            );
                            if (result != null) {
                              _bloc.add(
                                AddLocalPost(result.title, result.body),
                              );
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Create Post'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: state.posts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return PostTile(post: state.posts[index]);
                        },
                      ),
                    ),
                  ],
                ),
                ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.todos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      TodoTile(todo: state.todos[index]),
                ),
              ],
            );
          } else if (state is UserDetailFailure) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    _tabController.dispose();
    super.dispose();
  }
}
