import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chatbot extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<Chatbot> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  void sendMessage(String message) async {
    _controller.clear();
    setState(() {
      messages.add({"text": message, "isUser": true});
    });

    var response = await http
        .get(Uri.parse('http://localhost:5000/answer?id=1&question=$message'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        messages.add({"text": data['answer'], "isUser": false});
      });
    } else {
      print('Failed to fetch data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                var message = messages[index];
                return ListTile(
                  title: Text(message['text']),
                  subtitle: message['isUser'] ? Text('You') : Text('Bot'),
                  tileColor:
                      message['isUser'] ? Colors.blue[100] : Colors.grey[200],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  visualDensity: VisualDensity.compact,
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: IconTheme(
              data: IconThemeData(color: Colors.indigo),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: sendMessage,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Send a message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => sendMessage(_controller.text),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
