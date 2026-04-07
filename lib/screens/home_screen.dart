import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'chatbot_screen.dart';
import 'symptom_checker_screen.dart';
import 'navigation_screen.dart';
import 'appointment_screen.dart';
import 'emergency_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final lang = state.language;

    final labels = _getLabels(lang);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)], // blue-600 to blue-700
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${labels['welcome']} 👋",
                            style: TextStyle(color: Colors.blue[100], fontSize: 14),
                          ),
                          const Text(
                            "MediBot Assistant",
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _IconButton(
                            icon: Icons.warning_amber_rounded,
                            color: Colors.red[500]!,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const EmergencyScreen())),
                          ),
                          const SizedBox(width: 8),
                          _IconButton(
                            icon: Icons.notifications_none_rounded,
                            color: Colors.white.withOpacity(0.2),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    labels['subtitle']!,
                    style: TextStyle(color: Colors.blue[100], fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  // Language Selector
                  Row(
                    children: [
                      _LangChip(Language.english, '🇬🇧 EN', state),
                      const SizedBox(width: 8),
                      _LangChip(Language.hindi, '🇮🇳 HI', state),
                      const SizedBox(width: 8),
                      _LangChip(Language.marathi, '🇮🇳 MR', state),
                    ],
                  ),
                ],
              ),
            ),

            // Hospital Card
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                  border: Border.all(color: Colors.grey[100]!),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      child: const Text("🏥", style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("City General Hospital", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("NABH Accredited • 24/7 Emergency", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        const Text("Open", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Quick Access Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "QUICK ACCESS",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      _FeatureCard(
                        title: labels['chat']!,
                        desc: labels['chat_desc']!,
                        icon: Icons.chat_bubble_outline_rounded,
                        colors: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ChatbotScreen())),
                      ),
                      _FeatureCard(
                        title: labels['symptom']!,
                        desc: labels['symptom_desc']!,
                        icon: Icons.medical_services_outlined,
                        colors: const [Color(0xFF22C55E), Color(0xFF16A34A)],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SymptomCheckerScreen())),
                      ),
                      _FeatureCard(
                        title: labels['navigate']!,
                        desc: labels['navigate_desc']!,
                        icon: Icons.map_outlined,
                        colors: const [Color(0xFF6366F1), Color(0xFF4F46E5)],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const NavigationScreen())),
                      ),
                      _FeatureCard(
                        title: labels['appointment']!,
                        desc: labels['appointment_desc']!,
                        icon: Icons.calendar_today_outlined,
                        colors: const [Color(0xFF0D9488), Color(0xFF14B8A6)],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AppointmentScreen())),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Emergency Banner
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const EmergencyScreen())),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.red.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.warning_amber_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(labels['emergency']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const Text("Call 102 • Immediate Assistance", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Colors.white70),
                    ],
                  ),
                ),
              ),
            ),

            // Quick Tips
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "QUICK TIPS",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: Column(
                      children: [
                        _TipRow("💊", "Pharmacy open 24/7 — Floor 1", "Prescription & OTC medicines", true),
                        _TipRow("📋", "Lab reports available online", "Download in 24 hours", true),
                        _TipRow("🩺", "Next health camp: 5 April", "Free checkup for all patients", false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getLabels(Language lang) {
    switch (lang) {
      case Language.english:
        return {
          'welcome': 'Good Morning',
          'subtitle': 'How can I assist you today?',
          'chat': 'Chat with AI Doctor',
          'chat_desc': 'AI-powered medical Q&A',
          'symptom': 'Check Symptoms',
          'symptom_desc': 'Identify conditions',
          'navigate': 'Hospital Navigation',
          'navigate_desc': 'Find departments',
          'appointment': 'Book Appointment',
          'appointment_desc': 'Schedule with doctor',
          'emergency': 'Emergency Help',
        };
      case Language.hindi:
        return {
          'welcome': 'सुप्रभात',
          'subtitle': 'आज मैं आपकी कैसे मदद कर सकता हूं?',
          'chat': 'AI डॉक्टर से चैट करें',
          'chat_desc': 'AI-संचालित चिकित्सा Q&A',
          'symptom': 'लक्षण जांचें',
          'symptom_desc': 'स्थिति और विभाग पहचानें',
          'navigate': 'अस्पताल नेविगेशन',
          'navigate_desc': 'विभाग और कमरे खोजें',
          'appointment': 'अपॉइंटमेंट बुक करें',
          'appointment_desc': 'डॉक्टर के साथ शेड्यूल करें',
          'emergency': 'आपातकालीन मदद',
        };
      case Language.marathi:
        return {
          'welcome': 'शुभ प्रभात',
          'subtitle': 'आज मी तुम्हाला कशी मदत करू शकतो?',
          'chat': 'AI डॉक्टरशी चॅट करा',
          'chat_desc': 'AI-शक्तीचलित वैद्यकीय Q&A',
          'symptom': 'लक्षणे तपासा',
          'symptom_desc': 'स्थिती आणि विभाग ओळखा',
          'navigate': 'रुग्णालय नेव्हिगेशन',
          'navigate_desc': 'विभाग आणि खोल्या शोधा',
          'appointment': 'अपॉइंटमेंट बुक करा',
          'appointment_desc': 'डॉक्टरसोबत शेड्यूल करा',
          'emergency': 'आपत्कालीन मदत',
        };
    }
  }
}

class _LangChip extends StatelessWidget {
  final Language lang;
  final String label;
  final AppState state;
  const _LangChip(this.lang, this.label, this.state);

  @override
  Widget build(BuildContext context) {
    final isSelected = state.language == lang;
    return InkWell(
      onTap: () => state.setLanguage(lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1D4ED8) : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;
  const _FeatureCard({required this.title, required this.desc, required this.icon, required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(color: colors[1].withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const Spacer(),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final String icon;
  final String text;
  final String sub;
  final bool showDivider;
  const _TipRow(this.icon, this.text, this.sub, this.showDivider);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey[50], indent: 60),
      ],
    );
  }
}
