import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalapp/HomePage/Home.dart';

class UserCredentials {
  static String userEmail = '';
}

class loginpatients extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<loginpatients> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController useremailController = TextEditingController();
  final TextEditingController userpasswordController = TextEditingController();

  final CollectionReference mobileUsersCollection =
      FirebaseFirestore.instance.collection('Mobile_Users');

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();

  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[],
                    ),
                  ),
                  Container(
                    child: withEmailPassword(),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget withEmailPassword() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(right: 28, left: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 180,
              child: Image.asset(
                'assets/images/Admin.jpg',
                scale: 3.5,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              focusNode: f1,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              keyboardType: TextInputType.emailAddress,
              controller: useremailController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 20,
                  top: 10,
                  bottom: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                ),
                hintText: ' Email',
                hintStyle: TextStyle(
                  fontFamily: 'playfair',
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                errorText: _emailError,
              ),
              onFieldSubmitted: (value) {
                f1.unfocus();
                FocusScope.of(context).requestFocus(f2);
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  setState(() {
                    _emailError = 'Please enter the Email';
                  });
                  return null;
                } else if (!emailValidate(value)) {
                  setState(() {
                    _emailError = 'Please enter correct Email';
                  });
                  return null;
                } else {
                  setState(() {
                    _emailError = null;
                  });
                  return null;
                }
              },
            ),
            SizedBox(
              height: 25.0,
            ),
            TextFormField(
              focusNode: f2,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              controller: userpasswordController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                ),
                hintText: ' Password',
                hintStyle: TextStyle(
                  fontFamily: 'playfair',
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                errorText: _passwordError,
              ),
              onFieldSubmitted: (value) {
                f2.unfocus();
                FocusScope.of(context).requestFocus(f3);
              },
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value!.isEmpty) {
                  setState(() {
                    _passwordError = 'Please enter the Password';
                  });
                  return null;
                } else {
                  setState(() {
                    _passwordError = null;
                  });
                  return null;
                }
              },
              obscureText: true,
            ),
            Container(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                width: 150,
                height: 44,
                child: ElevatedButton(
                  focusNode: f3,
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      fontFamily: 'playfair',
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    _signIn(context);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    primary: Colors.indigo[900],
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn(BuildContext context) async {
    String email = useremailController.text.trim();
    String password = userpasswordController.text.trim();
    QuerySnapshot querySnapshot = await mobileUsersCollection
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      UserCredentials.userEmail = email;

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MainHomePage(
          email: email,
          showNotification: true,
        ),
      ));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sign In Failed'),
            content: Text('Invalid email or password. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  bool emailValidate(String email) {
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailRegex).hasMatch(email);
  }
}
