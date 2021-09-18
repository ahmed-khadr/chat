import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';
  void _sendMessage() {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
    });
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).colorScheme.primary,
                  style: BorderStyle.solid,
                ),
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Send a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(5),
                ),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              ),
            ),
          ),
          IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
    );
  }
}
