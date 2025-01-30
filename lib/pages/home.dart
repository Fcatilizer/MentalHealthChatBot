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
  String _text = 'Press the button and start speaking your mind!';

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
          if (val == 'done') _restartListening();
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
          listenMode: stt.ListenMode.dictation,
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
        listenMode: stt.ListenMode.dictation,
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
      appBar: AppBar(title: const Text('Speak your Mind')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Indicator (Recording / Not Recording)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _isListening ? 'Recording...' : 'Not Recording',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15.0,
                ),
              ),
            ),
            // Expandable Text Card (Fixed Width, Dynamic Height)
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 50.0, // Minimum height for short texts
                      maxHeight: constraints.maxHeight * 0.6, // Limits growth
                    ),
                    child: SizedBox(
                      width: double.infinity, // Ensures full width usage
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Text(
                              _text,
                              style: const TextStyle(fontSize: 20.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Fixed "Hello World" Card (Fixed Width)
            SizedBox(
              width: double.infinity, // Ensures width remains static
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hello World",
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button - Changes position and size when recording
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isListening
            ? SizedBox(
          width: 80, // Large button size
          height: 80,
          child: FloatingActionButton(
            onPressed: _listen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.pause, size: 36),
          ),
        )
            : FloatingActionButton(
          onPressed: _listen,
          child: const Icon(Icons.mic),
        ),
      ),
      floatingActionButtonLocation: _isListening
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat, // Moves button when recording
    );
  }
}
