import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'appointment_screen.dart';
import 'symptom_checker_screen.dart';
import 'navigation_screen.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _input = TextEditingController();
  final List<Message> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add(Message(text: "Hello! I am your AI assistant. How can I help you today?", isUser: false));
  }

  void _onSend() {
    if (_input.text.isEmpty) return;
    setState(() {
      _messages.add(Message(text: _input.text, isUser: true));
      _isTyping = true;
    });
    final text = _input.text;
    _input.clear();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isTyping = false;
        _messages.add(Message(text: "That's a great question! For a detailed analysis of '$text', I suggest we check your symptoms. Shall we proceed?", isUser: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppState>(context).language;
    final labels = _getLabels(lang);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Container(width: 32, height: 32, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle), alignment: Alignment.center, child: const Text("🤖", style: TextStyle(fontSize: 14))),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("AI Medical Assistant", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)), const SizedBox(width: 4), const Text("Online", style: TextStyle(fontSize: 10, color: Colors.white70))]),
            ]),
          ],
        ),
        backgroundColor: const Color(0xFF2563EB),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (c, i) {
                if (i == _messages.length) return _TypingIndicator();
                return _MessageBubble(_messages[i]);
              },
            ),
          ),
          
          if (_messages.length >= 2) ...[
             const Divider(height: 1),
             _QuickRepliesView(labels, onSelect: (r) {
                if (r == labels['book']) Navigator.push(context, MaterialPageRoute(builder: (c) => const AppointmentScreen()));
                if (r == labels['symptom']) Navigator.push(context, MaterialPageRoute(builder: (c) => const SymptomCheckerScreen()));
                if (r == labels['navigate']) Navigator.push(context, MaterialPageRoute(builder: (c) => const NavigationScreen()));
             }),
          ],
          
          _InputSection(_input, _onSend, labels['input']!),
        ],
      ),
    );
  }

  Map<String, String> _getLabels(Language lang) {
     return {
       'input': lang == Language.english ? 'Type message...' : lang == Language.hindi ? 'संदेश लिखें...' : 'संदेश लिहा...',
       'book': lang == Language.english ? 'Book Appointment' : lang == Language.hindi ? 'अपॉइंटमेंट बुक करें' : 'अपॉइंटमेंट बुक करा',
       'symptom': lang == Language.english ? 'Check Symptoms' : lang == Language.hindi ? 'लक्षण जांचें' : 'लक्षणे तपासा',
       'navigate': lang == Language.english ? 'Navigate Dept' : lang == Language.hindi ? 'नेविगेट विभाग' : 'नेव्हिगेट विभाग',
     };
  }
}

class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});
}

class _MessageBubble extends StatelessWidget {
  final Message msg;
  const _MessageBubble(this.msg);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: msg.isUser ? const Color(0xFF2563EB) : Colors.grey[100],
            borderRadius: BorderRadius.only(
               topLeft: const Radius.circular(20),
               topRight: const Radius.circular(20),
               bottomLeft: Radius.circular(msg.isUser ? 20 : 0),
               bottomRight: Radius.circular(msg.isUser ? 0 : 20),
            ),
          ),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: Text(msg.text, style: TextStyle(color: msg.isUser ? Colors.white : Colors.black87, fontSize: 14)),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 16), child: Row(children: [const Text("AI is typing...", style: TextStyle(color: Colors.grey, fontSize: 10, fontStyle: FontStyle.italic))]));
  }
}

class _QuickRepliesView extends StatelessWidget {
  final Map<String, String> labels;
  final Function(String) onSelect;
  const _QuickRepliesView(this.labels, {required this.onSelect});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
             _QuickReplyChip(labels['symptom']!, () => onSelect(labels['symptom']!)),
             _QuickReplyChip(labels['book']!, () => onSelect(labels['book']!)),
             _QuickReplyChip(labels['navigate']!, () => onSelect(labels['navigate']!)),
          ],
        ),
      ),
    );
  }
}

class _QuickReplyChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickReplyChip(this.label, this.onTap);
  @override
  Widget build(BuildContext context) {
     return Padding(padding: const EdgeInsets.only(right: 8), child: ActionChip(onPressed: onTap, label: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563))), side: BorderSide(color: Colors.grey[200]!), backgroundColor: Colors.white));
  }
}

class _InputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String hint;
  const _InputSection(this.controller, this.onSend, this.hint);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[100]!))),
      child: Row(
        children: [
           InkWell(onTap: () {}, child: const Icon(Icons.mic_none_rounded, color: Colors.blue)),
           const SizedBox(width: 12),
           Expanded(child: TextField(controller: controller, decoration: InputDecoration(hintText: hint, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 12)))),
           InkWell(onTap: onSend, child: Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle), child: const Icon(Icons.send_rounded, color: Colors.white, size: 20))),
        ],
      ),
    );
  }
}
