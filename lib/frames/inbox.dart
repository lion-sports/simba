import 'package:flutter/material.dart';

class Inbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: ListView(
        children: const <Widget>[
          ChatBubble(
            sender: 'John',
            message: 'Hey, how are you?',
            time: '10:00 AM',
            isMe: false,
          ),
          ChatBubble(
            sender: 'Me',
            message: 'I\'m good, thanks!',
            time: '10:02 AM',
            isMe: true,
          ),
          ChatBubble(
            sender: 'John',
            message: 'Do you want to grab lunch today?',
            time: '10:05 AM',
            isMe: false,
          ),
          // Add more chat bubbles as needed
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String sender;
  final String message;
  final String time;
  final bool isMe;

  const ChatBubble({required this.sender, required this.message, required this.time, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
