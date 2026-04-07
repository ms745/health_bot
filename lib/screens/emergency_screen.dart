import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool _called = false;

  final List<Map<String, String>> _contacts = [
    {'name': 'Ambulance', 'number': '102', 'icon': '🚑', 'color': '0xFFEF4444'},
    {'name': 'Emergency', 'number': '108', 'icon': '🚨', 'color': '0xFFF97316'},
    {'name': 'Hospital', 'number': '1800-XXX-XXXX', 'icon': '🏥', 'color': '0xFF3B82F6'},
    {'name': 'Police', 'number': '100', 'icon': '👮', 'color': '0xFF6366F1'},
  ];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final labels = _getLabels(state.language);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Emergency Help", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFFDC2626),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // BIG SOS button
            InkWell(
              onTap: () => setState(() => _called = true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFDC2626), Color(0xFFB91C1C)]),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: Column(
                  children: [
                    Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.phone_rounded, color: Colors.white, size: 40)),
                     const SizedBox(height: 20),
                     const Text("CALL EMERGENCY", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                     const Text("Tap to call 102 — Ambulance", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            
            if (_called) ...[
               const SizedBox(height: 16),
               Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.green[50], border: Border.all(color: Colors.green[200]!), borderRadius: BorderRadius.circular(16)), child: Row(children: [const Icon(Icons.check_circle_rounded, color: Colors.green), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Call Initiated", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)), const Text("Help is on the way. Stay calm.", style: TextStyle(color: Colors.green, fontSize: 12))])])),
            ],
            
            const SizedBox(height: 32),
            const Align(alignment: Alignment.centerLeft, child: Text("EMERGENCY CONTACTS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1))),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: _contacts.map((c) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Color(int.parse(c['color']!)), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(c['icon']!, style: const TextStyle(fontSize: 24)),
                     const Spacer(),
                     Text(c['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                     Text(c['number']!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                  ],
                ),
              )).toList(),
            ),

            const SizedBox(height: 32),
            const Align(alignment: Alignment.centerLeft, child: Text("FIRST AID GUIDE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1))),
            const SizedBox(height: 16),
            _FirstAidCard("❤️", "CPR Guide", "30 compressions → 2 breaths → Repeat", Colors.red[50]!, Colors.red[700]!),
            _FirstAidCard("🩸", "Bleeding Control", "Apply firm pressure, elevate wound", Colors.orange[50]!, Colors.orange[700]!),
            _FirstAidCard("🔥", "Burns", "Cool with running water for 10 min", Colors.yellow[50]!, Colors.yellow[700]!),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getLabels(Language lang) {
     return {
       'card_title': lang == Language.english ? 'Emergency Instructions' : lang == Language.hindi ? 'आपातकालीन निर्देश' : 'आपत्कालीन सूचना',
     };
  }
}

class _FirstAidCard extends StatelessWidget {
  final String emoji, title, desc;
  final Color bg, color;
  const _FirstAidCard(this.emoji, this.title, this.desc, this.bg, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, border: Border.all(color: color.withOpacity(0.2)), borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(emoji, style: const TextStyle(fontSize: 24)),
           const SizedBox(width: 16),
           Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15)), Text(desc, style: TextStyle(color: Colors.grey[700], fontSize: 13))])),
        ],
      ),
    );
  }
}
