import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechScreen extends StatefulWidget {

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText _speech;
    bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;
  final Map<String, HighlightedWord> _highlights = {
    'wife': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold
      )
    ),
    'love':  HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.redAccent,
        fontWeight: FontWeight.bold
      )
    ),
    'treasure':  HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold
      )
    ),
    'heart':  HighlightedWord(
      onTap: () => print('heart'),
      textStyle: const TextStyle(
        color: Colors.pinkAccent,
        fontWeight: FontWeight.bold
      )
    ),
    'comment':  HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.yellowAccent,
        fontWeight: FontWeight.bold
      )
    ),
  };

  void _listen() async {
    if (!_isListening) {
      bool avaialable = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (avaialable) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if(val.hasConfidenceRating && val.confidence > 0 ) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
        setState(() {
          _isListening = false;
          _speech.stop();
        });
      }

  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return (
      Scaffold(
        appBar: AppBar(
          title: Text('Confidence: ${(_confidence * 100).toStringAsFixed(1)}%')
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
          AvatarGlow(
            animate: _isListening,
            glowColor: Theme.of(context).primaryColor,
            endRadius: 75.0,
            duration: const Duration(milliseconds: 2000),
            repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),),
          ),
          body: SingleChildScrollView(
            reverse: true,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30.0,30.0,30.0,150.0),
              child: TextHighlight(
                text: _text,
                words: _highlights,
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400
                ),
              ),
            )
          ),
        )
    );
  }
}