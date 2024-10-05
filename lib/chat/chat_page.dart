import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:text_firebase/auth/auth_service.dart';
import 'package:text_firebase/chat/chat_buble.dart';
import 'package:text_firebase/chat/chat_service.dart';

class ChatPage extends StatelessWidget {
  final String userEmail;
  final String reciverId;

  ChatPage({super.key, required this.userEmail, required this.reciverId});

  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(reciverId, _messageController.text);
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        context.goNamed("/HomePage");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          title: Text(
            userEmail, style: TextStyle(color: Colors.white, fontSize: 20),),
          actions: [
            IconButton(
                onPressed: () {}, icon: Icon(Icons.video_camera_back_rounded)),
            IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildUserInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getuser()!.uid;

    return StreamBuilder(
        stream: _chatService.getMessages(reciverId, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool icCurrentUser = data['senderID'] == _authService.getuser()!.uid;

    var alignment =
    icCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(alignment: alignment,
        child: ChatBubble(message: data["message"], isCurrentUser: icCurrentUser,));
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        SizedBox(width: 10,),
        Expanded(
          child: TextFormField(
            controller: _messageController,
            obscureText: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              // Border around the TextFormField
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0), // Border color when focused
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0), // Border color when enabled
              ),
              hintText: 'Type your message here...',
              // Placeholder text
              hintStyle: TextStyle(color: Colors.grey),
              // Style for the placeholder text
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 15.0), // Padding inside the TextFormField
            ),
          ),
        ),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
      ],
    );
  }
}
