import 'package:flutter/material.dart';

class HospitalMapScreen extends StatefulWidget {
  const HospitalMapScreen({super.key});

  @override
  State<HospitalMapScreen> createState() => _HospitalMapScreenState();
}

class _HospitalMapScreenState extends State<HospitalMapScreen> {
  String _activeFloor = 'Floor 1';

  final List<Map<String, dynamic>> _floorConfigs = [
    {'key': 'Ground Floor', 'label': 'Ground Floor', 'color': Colors.red[700], 'bg': Colors.red[50], 'emoji': '🚑', 'rooms': ['Emergency', 'Reception', 'Pharmacy', 'Lab']},
    {'key': 'Floor 1', 'label': 'Floor 1', 'color': Colors.blue[700], 'bg': Colors.blue[50], 'emoji': '🏥', 'rooms': ['Cardiology', 'Neurology', 'Phlebotomy', 'OPD 1-10']},
    {'key': 'Floor 2', 'label': 'Floor 2', 'color': Colors.purple[700], 'bg': Colors.purple[50], 'emoji': '❤️', 'rooms': ['Pediatrics', 'Maternity', 'NICU', 'OPD 11-20']},
    {'key': 'Floor 3', 'label': 'Floor 3', 'color': Colors.orange[700], 'bg': Colors.orange[50], 'emoji': '🦴', 'rooms': ['Orthopedics', 'Physiotherapy', 'Dialysis', 'Surgery']},
  ];

  @override
  Widget build(BuildContext context) {
    final activeConfig = _floorConfigs.firstWhere((f) => f['key'] == _activeFloor);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hospital Map", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text("Interactive floor guide", style: TextStyle(color: Colors.teal[100], fontSize: 12)),
          ],
        ),
        backgroundColor: const Color(0xFF0D9488),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Floor switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _floorConfigs.map((f) {
                  final isSel = _activeFloor == f['key'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _activeFloor = f['key']),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: isSel ? const Color(0xFF0D9488) : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                        child: Text("${f['emoji']} ${f['label']}", style: TextStyle(color: isSel ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Map Card
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[100]!), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: activeConfig['bg'],
                          child: Row(
                            children: [
                              Text(activeConfig['emoji'], style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(activeConfig['label'], style: TextStyle(fontWeight: FontWeight.bold, color: activeConfig['color'], fontSize: 16)),
                                Text("${(activeConfig['rooms'] as List).length} areas on this floor", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                              ]),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               const Text("FLOOR LAYOUT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                               const SizedBox(height: 12),
                               Container(
                                 padding: const EdgeInsets.all(16),
                                 decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
                                 child: GridView.count(
                                   shrinkWrap: true,
                                   physics: const NeverScrollableScrollPhysics(),
                                   crossAxisCount: 2,
                                   mainAxisSpacing: 8,
                                   crossAxisSpacing: 8,
                                   childAspectRatio: 2.5,
                                   children: (activeConfig['rooms'] as List<String>).map((r) => Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: activeConfig['bg'], borderRadius: BorderRadius.circular(12), border: Border.all(color: activeConfig['color']!.withOpacity(0.2))),
                                      child: Text(r, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: activeConfig['color'])),
                                   )).toList(),
                                 ),
                               ),
                               const SizedBox(height: 12),
                               const Row(children: [Expanded(child: Divider(color: Colors.grey)), Text(" — Corridor — ", style: TextStyle(fontSize: 10, color: Colors.grey)), Expanded(child: Divider(color: Colors.grey))]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Route Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[100]!)),
                    child: Column(
                      children: [
                         Row(children: [const Icon(Icons.navigation_rounded, color: Color(0xFF0D9488), size: 16), const SizedBox(width: 8), const Text("Route Guidance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
                         const SizedBox(height: 12),
                         Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF0FDFA), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFCCFBF1))), child: const Text("Take the main elevator to the specified floor. Turn right after stepping out and follow the blue signs.", style: TextStyle(fontSize: 12, color: Color(0xFF134E4A), height: 1.5))),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Accessibility
                  Row(
                    children: [
                       Expanded(child: _AccessCard("🛗", "Elevator", "Near Reception", Colors.blue[50]!, Colors.blue[700]!)),
                       const SizedBox(width: 12),
                       Expanded(child: _AccessCard("♿", "Accessible", "All floors", Colors.green[50]!, Colors.green[700]!)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessCard extends StatelessWidget {
  final String emoji, title, desc;
  final Color bg, color;
  const _AccessCard(this.emoji, this.title, this.desc, this.bg, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(
        children: [
           Text(emoji, style: const TextStyle(fontSize: 24)),
           const SizedBox(height: 4),
           Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12)),
           Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
