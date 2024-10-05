import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:text_firebase/auth/auth_service.dart';
import 'package:text_firebase/chat/chat_service.dart';
import 'package:text_firebase/customWidget/myDrawer.dart';
import 'package:text_firebase/customWidget/user_tile.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService authService = AuthService();

  // void logout() {
  //   final _auth = AuthService();
  //   _auth.signOut();
  //   context.goNamed("/LoginPage");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: ()async{
                await authService.signOut();
                context.goNamed("/LoginPage");
              },
              icon: const Icon(
                Icons.exit_to_app_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: _userList(),
      drawer: const MyDrawer(),
    );
  }

  Widget _userList() {
    return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircleAvatar();
          }

          return ListView(
            children: snapshot.data!
                .map<Widget>((userData) => _builsUserList(userData, context))
                .toList(),
          );
        });
  }

  Widget _builsUserList(Map<String, dynamic> userData, BuildContext context) {


    if (userData['email'] != AuthService().getuser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          context.goNamed('/ChatPage', extra: userData);
        },
      );
    } else {
      return Container();
    }
  }
}
