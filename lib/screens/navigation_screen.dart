import 'package:flutter/material.dart';
import 'hospital_map_screen.dart';
import 'department_detail_screen.dart';

class NavigationScreen extends StatefulWidget {
  final String? highlightDept;
  const NavigationScreen({super.key, this.highlightDept});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Map<String, String>> _depts = [
    {'name': 'Cardiology', 'floor': 'Floor 1', 'id': 'cardiology', 'emoji': '🫀'},
    {'name': 'Neurology', 'floor': 'Floor 1', 'id': 'neurology', 'emoji': '🧠'},
    {'name': 'Orthopedics', 'floor': 'Floor 3', 'id': 'orthopedics', 'emoji': '🦴'},
    {'name': 'Pediatrics', 'floor': 'Floor 2', 'id': 'pediatrics', 'emoji': '👶'},
    {'name': 'Emergency', 'floor': 'Ground Floor', 'id': 'emergency', 'emoji': '🚑'},
    {'name': 'Pharmacy', 'floor': 'Ground Floor', 'id': 'pharmacy', 'emoji': '💊'},
    {'name': 'Laboratory', 'floor': 'Ground Floor', 'id': 'lab', 'emoji': '📋'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Hospital Navigation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF6366F1),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const HospitalMapScreen())), icon: const Icon(Icons.map_rounded)),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search department or room...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _depts.length,
              itemBuilder: (c, i) {
                 final d = _depts[i];
                 final isHighlighted = d['name'] == widget.highlightDept;
                 return Padding(
                   padding: const EdgeInsets.only(bottom: 12),
                   child: InkWell(
                     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DepartmentDetailScreen(deptId: d['id']!))),
                     child: Container(
                       padding: const EdgeInsets.all(16),
                       decoration: BoxDecoration(
                         color: isHighlighted ? const Color(0xFFEEF2FF) : Colors.white,
                         borderRadius: BorderRadius.circular(20),
                         border: Border.all(color: isHighlighted ? const Color(0xFF6366F1) : Colors.grey[100]!),
                         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
                       ),
                       child: Row(
                         children: [
                            Container(width: 48, height: 48, decoration: BoxDecoration(color: isHighlighted ? Colors.white : Colors.indigo[50], borderRadius: BorderRadius.circular(14)), alignment: Alignment.center, child: Text(d['emoji']!, style: const TextStyle(fontSize: 24))),
                            const SizedBox(width: 16),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                               Text(d['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                               Text(d['floor']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ])),
                            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                         ],
                       ),
                     ),
                   ),
                 );
              },
            ),
          ),
        ],
      ),
    );
  }
}
