import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async{
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    var userData =await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add(
        {
          'text': _enteredMessage,
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'userName': userData['userName'],
          'imageUrl': userData['imageUrl'],
        }
    );
    _controller.clear();
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
              height: 52,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black12),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Send a message...',
                  suffixIcon: IconButton(
                    onPressed:
                        _enteredMessage.trim().isEmpty ? null : _sendMessage,
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              ),
            ),
          ),
          // IconButton(
          //   onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          //   icon: Icon(
          //     Icons.send,
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          // ),
        ],
      ),
    );
  }
}
