import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];
  late DialogFlowtter _dialogFlowtter;

  @override
  void initState() {
    super.initState();
    _initializeDialogFlowtter();
  }

  Future<void> _initializeDialogFlowtter() async {
    // Initialize the DialogFlowtter instance with your credentials
    _dialogFlowtter = DialogFlowtter(
      credentials: DialogAuthCredentials.fromJson({
        "private_key": "4281ca770c700d04a3c11bef34d8ff6759a5093f",
        "client_email": "dialogflow2@aitour-yarx.iam.gserviceaccount.com",
      }),
    );
  }

  Future<void> _sendMessage() async {
    final userMessage = _messageController.text;
    if (userMessage.isNotEmpty) {
      setState(() {
        _messages.add('User: $userMessage');
        _messageController.clear();
      });

      if (_dialogFlowtter != null) {
        final response = await _dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: userMessage)),
        );

        if (response.message != null && response.message!.text != null) {
          final botReply = response.message!.text!.text;
          if (botReply != null && botReply.isNotEmpty) {
            setState(() {
              _messages.add('Bot: ${botReply[0]}');
            });
          } else {
            setState(() {
              _messages.add('Bot: No response');
            });
          }
        } else {
          setState(() {
            _messages.add('Bot: No message received');
          });
        }
      } else {
        print('DialogFlowtter has not been initialized yet');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8AA30D),
                Color(0xFF0D53A3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Type your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    print('Sending message: ${_messageController.text}');
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
