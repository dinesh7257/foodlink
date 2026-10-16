import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';

class VoiceSearchButton extends StatefulWidget {
  const VoiceSearchButton({Key? key}) : super(key: key);

  @override
  State<VoiceSearchButton> createState() => _VoiceSearchButtonState();
}

class _VoiceSearchButtonState extends State<VoiceSearchButton> {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
      color: _isListening ? Colors.red : null,
      onPressed: _toggleListening,
    );
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            if (result.finalResult) {
              final query = result.recognizedWords;
              Provider.of<FoodProvider>(context, listen: false).searchCenters(query);
              setState(() => _isListening = false);
            }
          },
        );
      }
    }
  }
}
