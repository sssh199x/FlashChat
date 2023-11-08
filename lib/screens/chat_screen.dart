import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String? messageText;

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose the controller when the widget is disposed
    messageController.dispose();
  }

  // void messagesStream() async {
  //   //Treat _firestore.collection('messages).snapshots() as list as it returns Stream<QuerySnapshot<Map<String, dynamic>>>
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  Future<void> addUser() {
    Timestamp timestamp = Timestamp.now();

    return _firestore
        .collection('messages')
        .add({
          'text': messageText,
          'sender': loggedInUser,
          'timestamp': timestamp
        })
        .then((value) =>
            print('Message added to the messages collection succesfully.'))
        .catchError((error) =>
            print('Failed to add message to the messages collection: $error'));
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user.email;
      }
    } catch (e) {
      print('Exception is: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                // messagesStream();
                //Implement logout functionality
                await _auth.signOut();

                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                List<MessageBubble> messageBubbless = [];
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                } else {
                  final messages = snapshot.data!.docs.reversed;

                  for (var message in messages) {
                    //if printed prints the data it contains in the data
                    //final messageData = message.data();

                    final messageText = message['text'];
                    final messageSender = message['sender'];
                    final messageSent = message['timestamp'];

                    final messageBubble = MessageBubble(
                      text: messageText,
                      sender: messageSender,
                      sentAt: messageSent,
                      isMe: loggedInUser == messageSender,
                    );

                    messageBubbless.add(messageBubble);
                  }
                }
                return Expanded(
                  child: ListView(
                    //Reversing the list so that it shows recent mssg at the bottom once it is sent by the sender but it also shows the message from the top so we also need to reverse the ...final messages = snapshot.data!.docs.reversed;... to get the message at bottom

                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    children: messageBubbless,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.

                      if (messageText?.isNotEmpty == true) {
                        // Check if messageText is not null and not empty
                        setState(() {
                          addUser();
                          //Reset the messageText value once it is added to the database through addUser() so that it wont send the previosly typed message when pressed send button as the condn above checks it.
                          messageText = '';

                          //Reset the messageText value shown in textfield  once it is added to the database through addUser().
                          messageController.clear();
                        });
                      }
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final Timestamp sentAt;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.text,
    required this.sender,
    required this.sentAt,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    // Convert Timestamp to DateTime
    DateTime dateTime = sentAt.toDate();
    //Format the dateTime to show only the time in 12-hour format('h:mm a') and for 24-hour format use ('HH:mm:ss')
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(sender, style: const TextStyle(color: Colors.black54)),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20)),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('sent: $formattedTime',
                style: const TextStyle(fontSize: 12, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
