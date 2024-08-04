// lib/screens/friend_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/friend_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

class FriendScreen extends StatefulWidget {
  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final friendProvider =
          Provider.of<FriendProvider>(context, listen: false);
      friendProvider.fetchFriends(authProvider.user!.id);
      friendProvider.fetchFriendRequests(authProvider.user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendProvider = Provider.of<FriendProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Friends'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Friends'),
              Tab(text: 'Friend Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFriendList(friendProvider.friends),
            _buildFriendRequestList(
                friendProvider.friendRequests, authProvider.user!.id),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.person_add),
          onPressed: () {
            // TODO: Implement add friend functionality
          },
        ),
      ),
    );
  }

  Widget _buildFriendList(List<User> friends) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                friend.photoUrl != null ? NetworkImage(friend.photoUrl!) : null,
            child: friend.photoUrl == null ? Text(friend.name[0]) : null,
          ),
          title: Text(friend.name),
          subtitle: Text(friend.email),
          trailing: IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              // TODO: Implement chat functionality
            },
          ),
        );
      },
    );
  }

  Widget _buildFriendRequestList(
      List<User> friendRequests, String currentUserId) {
    return ListView.builder(
      itemCount: friendRequests.length,
      itemBuilder: (context, index) {
        final request = friendRequests[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: request.photoUrl != null
                ? NetworkImage(request.photoUrl!)
                : null,
            child: request.photoUrl == null ? Text(request.name[0]) : null,
          ),
          title: Text(request.name),
          subtitle: Text(request.email),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  Provider.of<FriendProvider>(context, listen: false)
                      .acceptFriendRequest(currentUserId, request.id);
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  // TODO: Implement reject friend request functionality
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
