import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospitalapp/BMI/screens/imc_screen.dart';
import 'package:hospitalapp/ChatBot/Chatbot.dart';
import 'package:hospitalapp/MedicineReminder/pages/homee.dart';
import 'package:hospitalapp/PATIENTS/LogIN.dart';
import 'package:hospitalapp/PATIENTS/Profile.dart';
import 'package:hospitalapp/Screens/Appointement.dart';
import 'package:hospitalapp/Screens/HeartRate.dart';
import 'package:hospitalapp/Screens/Notifications.dart';
import 'package:hospitalapp/Screens/ReachUs.dart';
import 'package:hospitalapp/Screens/Results.dart';
import 'package:hospitalapp/Screens/WelcomeScren.dart';
import 'package:hospitalapp/Screens/feedback.dart';

class MainHomePage extends StatefulWidget {
  final String email;
  final bool showNotification;

  const MainHomePage({
    required this.email,
    required this.showNotification,
    Key? key,
  }) : super(key: key);

  @override
  State<MainHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainHomePage>
    with SingleTickerProviderStateMixin {
  String userName = 'User';
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool showNotification = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    showNotification = widget.showNotification;

    if (showNotification) {
      _showNotification();
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Mobile_Users')
          .where('email', isEqualTo: widget.email)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first);

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['firstname'] ?? 'User';
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  void _showNotification() {
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        showNotification = true;
      });
      _controller.forward();

      Future.delayed(Duration(seconds: 5), () {
        _controller.reverse().then((_) {
          setState(() {
            showNotification = false;
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(isDrawerOpen ? 0.85 : 1.00)
              ..rotateZ(isDrawerOpen ? -0.05 : 0),
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isDrawerOpen
                  ? BorderRadius.circular(40)
                  : BorderRadius.circular(0),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        title: Text('Hello, $userName',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'playfair')),
                        subtitle: Text('Welcome back',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'playfair')),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isDrawerOpen) {
                                xOffset = 0;
                                yOffset = 0;
                              } else {
                                xOffset = 290;
                                yOffset = 80;
                              }
                              isDrawerOpen = !isDrawerOpen;
                            });
                          },
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundImage: image,
                          ),
                        ),
                      ),
                      const SizedBox(height: 29)
                    ],
                  ),
                ),
                Container(
                  color: Colors.indigo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100),
                          bottomRight: Radius.circular(300),
                        )),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 40,
                      mainAxisSpacing: 30,
                      children: [
                        itemDashboard(
                            'Results',
                            'assets/images/result.png',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MedicalResultScreen()))),
                        itemDashboard(
                            'Medicines',
                            'assets/icons/reminder_843169.png',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => addMedicine()))),
                        itemDashboard(
                            'Chatbot',
                            'assets/icons/chatbot_2068868.png',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chatbot()))),
                        itemDashboard(
                            'Appointments',
                            'assets/icons/reminder.png',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Appointments()))),
                        itemDashboard(
                            'BMI',
                            'assets/icons/bmi.png',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImcScreen()))),
                        itemDashboard(
                            'Heart Rate Measure',
                            'assets/images/hheart.jpg',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HeartRate()))),
                        itemDashboard(
                            'Reach Us',
                            'assets/images/placeholder.png',
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReachUs()))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
          if (showNotification)
            Positioned(
              top: 140,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Notification: Your chatbot is ready to assist you!',
                          style: TextStyle(
                            fontFamily: 'playfair',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showNotification = false;
                          });
                          _controller.reverse();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.indigo),
                        ),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          height: 60,
          width: 65,
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.call,
              size: 33,
              color: Colors.indigo,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget itemDashboard(String title, String imagePath, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              child: Image.asset(imagePath),
            ),
            const SizedBox(height: 12),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'playfair'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String email = UserCredentials.userEmail;
    return Container(
      color: Colors.indigo,
      child: Padding(
        padding: EdgeInsets.only(top: 50, left: 40, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainHomePage(
                                  email: email,
                                  showNotification: false,
                                )));
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  'MedCare',
                  style: TextStyle(
                      fontFamily: 'playfair',
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(title: 'profile')));
                  },
                  child: NewRow(
                    text: 'Profile',
                    icon: Icons.person,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationsPage()));
                  },
                  child: NewRow(
                    text: 'Notifications',
                    icon: Icons.notification_add,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                NewRow(
                  text: 'Settings',
                  icon: Icons.error,
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactUsPage()));
                  },
                  child: NewRow(
                    text: 'Feedback',
                    icon: Icons.feedback,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen11()));
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 33,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Log out',
                    style: TextStyle(
                        fontFamily: 'playfair',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const NewRow({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: 33,
          color: Colors.white,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          text,
          style: TextStyle(
              fontFamily: 'playfair',
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
