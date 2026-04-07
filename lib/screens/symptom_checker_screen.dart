import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'navigation_screen.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final TextEditingController _search = TextEditingController();
  final Set<String> _selected = {};
  bool _analyzing = false;
  bool _showResult = false;

  final List<String> _commonSymptoms = [
    'Chest Pain', 'Fever', 'Headache', 'Cough', 'Stomach Ache', 'Back Pain',
    'Breathlessness', 'Dizziness', 'Sore Throat', 'Nausea', 'Fatigue', 'Joint Pain'
  ];

  final Map<String, String> _recommendations = {
    'Chest Pain': 'Cardiology OPD',
    'Breathlessness': 'Emergency Room',
    'Fever': 'General Medicine',
    'Headache': 'Neurology OPD',
    'Stomach Ache': 'Gastroenterology',
    'Back Pain': 'Orthopedics OPD',
    'Cough': 'Pulmonology OPD',
  };

  void _onAnalyze() async {
    if (_selected.isEmpty && _search.text.isEmpty) return;
    setState(() => _analyzing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _analyzing = false;
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) return _buildResultView();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Symptom Checker", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF16A34A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text("HOW ARE YOU FEELING?", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                   const SizedBox(height: 12),
                   TextField(
                     controller: _search,
                     decoration: InputDecoration(
                        hintText: "Search symptoms...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!)),
                     ),
                   ),
                   const SizedBox(height: 24),
                   const Text("COMMON SYMPTOMS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                   const SizedBox(height: 16),
                   Wrap(
                     spacing: 8,
                     runSpacing: 8,
                     children: _commonSymptoms.map((s) {
                       final isSel = _selected.contains(s);
                       return InkWell(
                         onTap: () => setState(() => isSel ? _selected.remove(s) : _selected.add(s)),
                         child: Container(
                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                           decoration: BoxDecoration(
                             color: isSel ? const Color(0xFF16A34A) : Colors.white,
                             borderRadius: BorderRadius.circular(20),
                             border: Border.all(color: isSel ? const Color(0xFF16A34A) : Colors.grey[200]!),
                           ),
                           child: Text(s, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSel ? Colors.white : Colors.black87)),
                         ),
                       );
                     }).toList(),
                   ),
                ],
              ),
            ),
          ),
          
          if (_selected.isNotEmpty || _search.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _analyzing ? null : _onAnalyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _analyzing 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Analyze Symptoms", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    final first = _selected.isEmpty ? _search.text : _selected.first;
    final dept = _recommendations[first] ?? "General Medicine";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Analysis Result"), backgroundColor: const Color(0xFF16A34A), iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
               padding: const EdgeInsets.all(20),
               decoration: BoxDecoration(color: const Color(0xFFF0FDF4), border: Border.all(color: const Color(0xFFDCFCE7)), borderRadius: BorderRadius.circular(24)),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    const Text("RECOMMENDED DEPARTMENT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534), letterSpacing: 1)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                         const Icon(Icons.apartment_rounded, color: Color(0xFF16A34A), size: 32),
                         const SizedBox(width: 16),
                         Text(dept, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF14532D))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text("Based on your symptoms, we suggest visiting this department for a detailed consultation.", style: TextStyle(color: Color(0xFF166534), fontSize: 13)),
                 ],
               ),
             ),
             const SizedBox(height: 32),
             const Text("NEXT STEPS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
             const SizedBox(height: 16),
             _StepRow(1, "Go to Floor 1, Wing A", "Navigate there now using hospital map."),
             _StepRow(2, "Register at counter", "Use your patient ID for faster check-in."),
             _StepRow(3, "Consult Doctor", "Discuss your symptoms: ${(_selected.toList()..addAll(_search.text.split(','))).join(', ')}"),
             const Spacer(),
             Row(
               children: [
                  Expanded(child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => NavigationScreen(highlightDept: dept))),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF16A34A), minimumSize: const Size(0, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    child: const Text("Navigate Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )),
                  const SizedBox(width: 12),
                  _CircleButton(icon: Icons.refresh, onTap: () => setState(() { _showResult = false; _selected.clear(); _search.clear(); })),
               ],
             ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int step;
  final String title, desc;
  const _StepRow(this.step, this.title, this.desc);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 24, height: 24, decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle), alignment: Alignment.center, child: Text("$step", style: const TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold, fontSize: 13))),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 13))])),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, child: Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: Colors.grey[600])));
  }
}
