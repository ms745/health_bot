import 'package:flutter/material.dart';
import 'appointment_screen.dart';
import 'hospital_map_screen.dart';

class DepartmentDetailScreen extends StatelessWidget {
  final String deptId;
  const DepartmentDetailScreen({super.key, required this.deptId});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dept = _getDeptData(deptId);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dept['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text(dept['floorLabel'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        backgroundColor: const Color(0xFF4F46E5),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 16), child: Text(dept['emoji'], style: const TextStyle(fontSize: 24))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[100]!)),
              child: Text(dept['description'], style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.6)),
            ),
            const SizedBox(height: 16),

            // Location & Hours
            Row(
              children: [
                Expanded(child: _InfoBox(Icons.location_on_outlined, "Location", dept['location'], dept['floorLabel'], Colors.blue[50]!, Colors.blue[700]!)),
                const SizedBox(width: 12),
                Expanded(child: _InfoBox(Icons.access_time_rounded, "Hours", dept['hours'], "Mon - Sat", Colors.green[50]!, Colors.green[700]!)),
              ],
            ),
            const SizedBox(height: 16),

            // Directions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[100]!)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [Icon(Icons.directions_walk_rounded, color: Color(0xFF4F46E5), size: 18), SizedBox(width: 8), Text("How to Get Here", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
                  const SizedBox(height: 12),
                  Container(padding: const EdgeInsets.all(12), width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE0E7FF))), child: Text(dept['route'], style: const TextStyle(fontSize: 13, color: Color(0xFF3730A3)))),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const HospitalMapScreen())),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text("View Hospital Map", style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Doctors
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[100]!)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Row(children: [Icon(Icons.person_outline_rounded, color: Colors.grey, size: 18), SizedBox(width: 8), Text("Available Doctors", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
                   const SizedBox(height: 12),
                   ... (dept['doctors'] as List<String>).map((doc) => Padding(
                     padding: const EdgeInsets.only(bottom: 8),
                     child: Container(
                       padding: const EdgeInsets.all(12),
                       decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(14)),
                       child: Row(
                         children: [
                            Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle), alignment: Alignment.center, child: const Text("👨‍⚕️", style: TextStyle(fontSize: 14))),
                            const SizedBox(width: 12),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(doc, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), const Text("Specialist", style: TextStyle(fontSize: 11, color: Colors.grey))]),
                            const Spacer(),
                            Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)), const SizedBox(width: 4), const Text("Available", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold))]),
                         ],
                       ),
                     ),
                   )).toList(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => AppointmentScreen(preselectedDept: dept['name']))),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.calendar_month, color: Colors.white), SizedBox(width: 8), Text("Book Appointment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), side: BorderSide(color: Colors.grey[200]!)),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.phone_outlined, color: Colors.black54), SizedBox(width: 8), Text("Call Department", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))]),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getDeptData(String id) {
     return {
       'cardiology': {
         'name': 'Cardiology',
         'floorLabel': 'Floor 1',
         'emoji': '🫀',
         'description': 'Advanced care for heart-related conditions, including diagnostics and surgical consultations.',
         'location': 'Wing A, Floor 1',
         'hours': '9 AM - 5 PM',
         'route': 'Take the main elevator to Floor 1. Turn right and follow the blue cardiology signs.',
         'doctors': ['Dr. Sharma', 'Dr. Patil']
       },
       'neurology': {
         'name': 'Neurology',
         'floorLabel': 'Floor 1',
         'emoji': '🧠',
         'description': 'Specialized treatment for brain, spinal cord, and nerve disorders.',
         'location': 'Wing B, Floor 1',
         'hours': '9 AM - 5 PM',
         'route': 'Take the main elevator to Floor 1. Turn left and proceed to Wing B.',
         'doctors': ['Dr. Deshmukh', 'Dr. Kulkarni']
       },
       'emergency': {
         'name': 'Emergency',
         'floorLabel': 'Ground Floor',
         'emoji': '🚑',
         'description': 'Immediate medical attention for life-threatening conditions. Open 24/7.',
         'location': 'Main Entrance, Ground Floor',
         'hours': '24/7',
         'route': 'Located immediately to the right of the main entrance gate.',
         'doctors': ['Dr. Gupta', 'Dr. Reddy']
       },
       'pediatrics': {
         'name': 'Pediatrics',
         'floorLabel': 'Floor 2',
         'emoji': '👶',
         'description': 'Comprehensive medical care for infants, children, and adolescents.',
         'location': 'Wing A, Floor 2',
         'hours': '9 AM - 5 PM',
         'route': 'Take the main elevator to Floor 2. Turn right and follow the colorful decals.',
         'doctors': ['Dr. Singh', 'Dr. Verma']
       },
       'orthopedics': {
         'name': 'Orthopedics',
         'floorLabel': 'Floor 3',
         'emoji': '🦴',
         'description': 'Treatment for musculoskeletal system issues, including bones, joints, and ligaments.',
         'location': 'Wing B, Floor 3',
         'hours': '9 AM - 5 PM',
         'route': 'Take the main elevator to Floor 3. Turn left and proceed to the physio wing.',
         'doctors': ['Dr. Joshi', 'Dr. More']
       },
       'pharmacy': {
         'name': 'Pharmacy',
         'floorLabel': 'Ground Floor',
         'emoji': '💊',
         'description': '24/7 pharmacy service for all prescription and OTC medications.',
         'location': 'Ground Floor, Near Exit',
         'hours': '24/7',
         'route': 'Located near the main exit door on the ground floor.',
         'doctors': ['Lead Pharmacist']
       },
       'lab': {
         'name': 'Laboratory',
         'floorLabel': 'Ground Floor',
         'emoji': '📋',
         'description': 'Diagnostic testing services including blood tests, X-ray, and pathology.',
         'location': 'Ground Floor, Wing C',
         'hours': '24/7',
         'route': 'Proceed past the reception and turn left into Wing C.',
         'doctors': ['Lab Supervisor']
       },
     }[id] ?? {
        'name': 'Department',
        'floorLabel': 'Ground Floor',
        'emoji': '🏥',
        'description': 'General hospital services and patient care.',
        'location': 'Main Building',
        'hours': '9 AM - 5 PM',
        'route': 'Please consult the main reception for directions.',
        'doctors': ['Dr. Team']
     };
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String title, val1, val2;
  final Color bg, color;
  const _InfoBox(this.icon, this.title, this.val1, this.val2, this.bg, this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12)),
          const SizedBox(height: 4),
          Text(val1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(val2, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}
