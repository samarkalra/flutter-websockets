import "package:flutter/material.dart";
import "package:web_socket_channel/io.dart";
import "package:web_socket_channel/web_socket_channel.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WebSocketChannel _channel;
  final _controller = TextEditingController();
  String messageFromSocket = 'No Message';

  @override
  void initState() {
    super.initState();
    _channel = IOWebSocketChannel.connect(
      Uri.parse('wss://echo.websocket.events'),
    );
    _channel.stream.listen((event) {
      setState(() {
        messageFromSocket = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close();
  }

  void _sendMessage() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            // StreamBuilder(
            //   stream: _channel.stream,
            //   builder: (context, snapshot) {
            //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
            //   },
            // )
            Text(messageFromSocket)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
