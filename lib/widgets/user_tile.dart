import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/user_detail_screen.dart';

class UserTile extends StatelessWidget {
  final User user;
  const UserTile({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.image)),
      title: Text('${user.firstName} ${user.lastName}'),
      subtitle: SizedBox(
        width: screenWidth * 0.6,
        child: Text(
          user.email,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
      ),
    );
  }
}
