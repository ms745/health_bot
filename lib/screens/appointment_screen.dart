import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class AppointmentScreen extends StatefulWidget {
  final String? preselectedDept;
  const AppointmentScreen({super.key, this.preselectedDept});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  int _step = 1;
  String? _selectedDept;
  String? _selectedDoc;
  String? _selectedDate;
  String? _selectedTime;
  bool _isConfirmed = false;

  final List<String> _depts = ['Cardiology', 'Neurology', 'Orthopedics', 'Pediatrics', 'General Medicine'];
  final Map<String, List<String>> _doctors = {
    'Cardiology': ['Dr. Sharma', 'Dr. Patil'],
    'Neurology': ['Dr. Deshmukh', 'Dr. Kulkarni'],
    'Orthopedics': ['Dr. Joshi', 'Dr. More'],
    'Pediatrics': ['Dr. Singh', 'Dr. Verma'],
    'General Medicine': ['Dr. Gupta', 'Dr. Reddy'],
  };

  final List<String> _timeSlots = ['09:00 AM', '10:30 AM', '11:45 AM', '02:00 PM', '03:30 PM', '05:00 PM'];

  @override
  void initState() {
    super.initState();
    if (widget.preselectedDept != null) {
      _selectedDept = widget.preselectedDept;
      _step = 2;
    }
  }

  List<String> _generateDates() {
    final List<String> dates = [];
    final now = DateTime.now();
    for (int i = 1; i <= 7; i++) {
       final d = now.add(Duration(days: i));
       if (d.weekday != DateTime.sunday) {
         dates.add("${_weekday(d.weekday)} ${d.day.toString().padLeft(2, '0')} ${_month(d.month)}");
       }
    }
    return dates;
  }

  String _weekday(int d) => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][d - 1];
  String _month(int m) => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m - 1];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final labels = _getLabels(state.language);

    if (_isConfirmed) return _buildSuccessView(labels);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labels['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            const Text("Schedule with your preferred doctor", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        backgroundColor: const Color(0xFF0D9488),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Step Indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
            child: Row(
              children: [
                for (int i = 1; i <= 4; i++) ...[
                   _StepCircle(i, _step),
                   if (i < 4) Expanded(child: Container(height: 2, color: _step > i ? Colors.green[400] : Colors.grey[200])),
                ],
                const SizedBox(width: 12),
                Text("Step $_step of 4", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 1: Dept
                  _buildLabel(labels['select_dept']!),
                  _buildList(_depts, _selectedDept, (v) {
                    setState(() {
                      _selectedDept = v;
                      _selectedDoc = null;
                      _step = 2;
                    });
                  }),

                  // Step 2: Doc
                  if (_selectedDept != null) ...[
                    const SizedBox(height: 24),
                    _buildLabel(labels['select_doc']!),
                    _buildDoctorList(_doctors[_selectedDept!]!, _selectedDoc, (v) {
                      setState(() {
                        _selectedDoc = v;
                        _step = 3;
                      });
                    }),
                  ],

                  // Step 3: Date
                  if (_selectedDoc != null) ...[
                    const SizedBox(height: 24),
                    _buildLabel(labels['select_date']!),
                    _buildDateList(_generateDates(), _selectedDate, (v) {
                      setState(() {
                        _selectedDate = v;
                        _step = 4;
                      });
                    }),
                  ],

                  // Step 4: Time
                  if (_selectedDate != null) ...[
                    const SizedBox(height: 24),
                    _buildLabel(labels['select_time']!),
                    _buildTimeGrid(_timeSlots, _selectedTime, (v) {
                      setState(() {
                        _selectedTime = v;
                      });
                    }),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          if (_selectedDept != null && _selectedDoc != null && _selectedDate != null && _selectedTime != null)
            _buildConfirmButton(labels),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
    );
  }

  Widget _buildList(List<String> items, String? selected, Function(String) onSelect) {
    return Column(
      children: items.map((i) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () => onSelect(i),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: selected == i ? const Color(0xFF0D9488) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected == i ? const Color(0xFF0D9488) : Colors.grey[200]!),
            ),
            child: Text(i, style: TextStyle(fontWeight: FontWeight.w600, color: selected == i ? Colors.white : Colors.black87)),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildDoctorList(List<String> items, String? selected, Function(String) onSelect) {
    return Column(
      children: items.map((i) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () => onSelect(i),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: selected == i ? const Color(0xFF0D9488) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected == i ? const Color(0xFF14B8A6) : Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle), alignment: Alignment.center, child: const Text("👨‍⚕️", style: TextStyle(fontSize: 14))),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(i, style: TextStyle(fontWeight: FontWeight.bold, color: selected == i ? Colors.white : Colors.black87)),
                    Text(_selectedDept!, style: TextStyle(fontSize: 11, color: selected == i ? Colors.white70 : Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildDateList(List<String> items, String? selected, Function(String) onSelect) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((i) {
          final parts = i.split(' ');
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onSelect(i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: selected == i ? const Color(0xFF0D9488) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: selected == i ? const Color(0xFF0D9488) : Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Text(parts[0], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: selected == i ? Colors.white70 : Colors.grey)),
                    const SizedBox(height: 4),
                    Text(parts[1], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: selected == i ? Colors.white : Colors.black87)),
                    Text(parts[2], style: TextStyle(fontSize: 10, color: selected == i ? Colors.white70 : Colors.grey)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeGrid(List<String> items, String? selected, Function(String) onSelect) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.2,
      children: items.map((i) => InkWell(
        onTap: () => onSelect(i),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected == i ? const Color(0xFF0D9488) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected == i ? const Color(0xFF0D9488) : Colors.grey[200]!),
          ),
          child: Text(i, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected == i ? Colors.white : Colors.black87)),
        ),
      )).toList(),
    );
  }

  Widget _buildConfirmButton(Map<String, String> labels) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[100]!))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: const Color(0xFFF0FDFA), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFCCFBF1))),
            child: Column(
              children: [
                _SummaryRow("Department", _selectedDept!),
                _SummaryRow("Doctor", _selectedDoc!),
                _SummaryRow("Date", _selectedDate!),
                _SummaryRow("Time", _selectedTime!),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => setState(() => _isConfirmed = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(labels['confirm']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(Map<String, String> labels) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 96, height: 96, decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle), child: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 48)),
            const SizedBox(height: 24),
            Text(labels['success']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Your appointment has been booked successfully.", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            _buildAppointmentCard(),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => setState(() { _isConfirmed = false; _step = 1; _selectedDept = null; _selectedDoc = null; _selectedDate = null; _selectedTime = null; }),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("Book Another", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Home", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[100]!), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Column(
        children: [
           Row(
             children: [
                const Icon(Icons.calendar_month, color: Color(0xFF0D9488), size: 20),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("APT ID", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text("#APT${10000 + DateTime.now().millisecond}", style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
             ],
           ),
           const Divider(height: 32),
           _DetailRow("🏥", "Department", _selectedDept!),
           _DetailRow("👨‍⚕️", "Doctor", _selectedDoc!),
           _DetailRow("📅", "Date", _selectedDate!),
           _DetailRow("⏰", "Time", _selectedTime!),
        ],
      ),
    );
  }

  Map<String, String> _getLabels(Language lang) {
    return {
      'title': lang == Language.english ? 'Book Appointment' : lang == Language.hindi ? 'अपॉइंटमेंट बुक करें' : 'अपॉइंटमेंट बुक करा',
      'select_dept': lang == Language.english ? 'Select Department' : lang == Language.hindi ? 'विभाग चुनें' : 'विभाग निवडा',
      'select_doc': lang == Language.english ? 'Select Doctor' : lang == Language.hindi ? 'डॉक्टर चुनें' : 'डॉक्टर निवडा',
      'select_date': lang == Language.english ? 'Select Date' : lang == Language.hindi ? 'तारीख चुनें' : 'तारीख निवडा',
      'select_time': lang == Language.english ? 'Select Time Slot' : lang == Language.hindi ? 'समय स्लॉट चुनें' : 'वेळ स्लॉट निवडा',
      'confirm': lang == Language.english ? 'Confirm Appointment' : lang == Language.hindi ? 'पुष्टि करें' : 'पुष्टी करा',
      'success': lang == Language.english ? 'Appointment Confirmed!' : lang == Language.hindi ? 'पुष्टि हो गई!' : 'पुष्टी झाली!',
    };
  }
}

class _StepCircle extends StatelessWidget {
  final int step;
  final int currentStep;
  const _StepCircle(this.step, this.currentStep);
  @override
  Widget build(BuildContext context) {
    final active = step <= currentStep;
    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(color: active ? const Color(0xFF0D9488) : Colors.grey[100], shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(step < currentStep ? "✓" : "$step", style: TextStyle(color: active ? Colors.white : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  const _SummaryRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)), Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF111827)))]));
  }
}

class _DetailRow extends StatelessWidget {
  final String emoji, label, value;
  const _DetailRow(this.emoji, this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)), Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))])]));
  }
}

class _buildLabel extends StatelessWidget {
  final String text;
  const _buildLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)));
  }
}
