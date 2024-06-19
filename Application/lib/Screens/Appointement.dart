import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class Appointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appointment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => AppointmentProvider(),
        child: AppointmentPage(),
      ),
    );
  }
}

class AppointmentProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  List<Appointment> appointments = [];
}

class Appointment {
  final DateTime date;
  final String time;

  Appointment(this.date, this.time);
}

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      context.read<AppointmentProvider>().selectedTime = picked.format(context);
    }
  }

  void _confirmAppointment() async {
    var provider = context.read<AppointmentProvider>();
    
    CollectionReference appointments = FirebaseFirestore.instance.collection('appointments');
    
    await appointments.add({
      'date': provider.selectedDate,
      'time': provider.selectedTime,
      'createdAt': Timestamp.now(),
    });

    print('Appointment confirmed for ${DateFormat('yyyy-MM-dd').format(provider.selectedDate)} '
          'at ${provider.selectedTime}');


    provider.selectedTime = '';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String email = UserCredentials.userEmail; 
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainHomePage(
                          email: email,
                          showNotification: false,
                        )));
          },
        ),
        title: Text(
          'Appointment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(
                    context.read<AppointmentProvider>().selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  context.read<AppointmentProvider>().selectedDate =
                      selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => _selectTime(context),
              child: Text(
                'Select Time',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => _confirmAppointment(),
              child: Text(
                'Confirm Appointment',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            _buildAppointmentsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<Appointment> appointments = snapshot.data!.docs.map((DocumentSnapshot doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Appointment(
            data['date'].toDate(),
            data['time'],
          );
        }).toList();

        return Expanded(
          child: ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(
                    'Appointment: ${DateFormat('yyyy-MM-dd').format(appointment.date)} at ${appointment.time}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        onPressed: () => _editAppointment(appointment),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        onPressed: () => _deleteAppointment(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _deleteAppointment(int index) async {
    var provider = context.read<AppointmentProvider>();
    CollectionReference appointments = FirebaseFirestore.instance.collection('appointments');
    
    QuerySnapshot querySnapshot = await appointments.get();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.docs;
    
    documentSnapshot[index].reference.delete();
    provider.appointments.removeAt(index);
    setState(() {});
  }

  void _editAppointment(Appointment appointment) {
    print(
        'Edit appointment: ${DateFormat('yyyy-MM-dd').format(appointment.date)} at ${appointment.time}');
  }
}
