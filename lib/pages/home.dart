import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          if (val == 'done') {
            // Restart listening if done
            _restartListening();
          }
        },
        onError: (val) {
          print('onError: $val');
          _restartListening();
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
          listenMode: stt.ListenMode.dictation, // Use dictation mode for long recordings
        );
      } else {
        setState(() {
          _text = 'Speech recognition is not available on this device.';
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _restartListening() {
    if (_isListening) {
      _speech.stop();
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
        }),
        listenMode: stt.ListenMode.dictation, // Restart in dictation mode
      );
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Chat Bot'),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _isListening ? 'Recording...' : 'Not Recording',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _text,
                  style: const TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          key: ValueKey<bool>(_isListening),
          onPressed: _listen,
          child: Icon(_isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}