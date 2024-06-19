import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalapp/HomePage/Home.dart';
import 'package:hospitalapp/PATIENTS/LogIN.dart';

class Profile extends StatefulWidget {
  Profile({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DocumentSnapshot? userDocument;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String email = UserCredentials.userEmail;
    FirebaseFirestore.instance
        .collection('Mobile_Users')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userDocument = querySnapshot.docs.first;
        });
      }
    });
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    if (userDocument != null) {
      await FirebaseFirestore.instance
          .collection('Mobile_Users')
          .doc(userDocument!.id)
          .update(data);
      fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = UserCredentials.userEmail;
    if (userDocument == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    String profileImage = userDocument!['gender'] == 'male'
        ? 'assets/images/bagha.png'
        : 'assets/images/bagha.png';

    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            width: 415,
            decoration: BoxDecoration(color: Colors.indigo),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
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
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: _height / 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: AssetImage(profileImage),
                              radius: _height / 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: _height / 2.2),
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 240, left: _width / 20, right: _width / 20),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.indigo,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo,
                                    blurRadius: 2.0,
                                    offset: Offset(0.0, 2.0),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(_width / 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      userDocument!['firstname'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Playfair'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      userDocument!['lastname'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Playfair'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: _height / 30),
                            child: Column(
                              children: <Widget>[
                                infoChild(_width, Icons.email,
                                    userDocument!['email']),
                                infoChild(_width, Icons.call,
                                    userDocument!['phonenumber']),
                                infoChild(_width, Icons.date_range,
                                    userDocument!['birthdate']),
                                infoChild(_width, Icons.home,
                                    userDocument!['address']),
                                Padding(
                                  padding: EdgeInsets.only(top: _height / 25),
                                  child: InkWell(
                                    onTap: () => _showEditDialog(context),
                                    child: Container(
                                      width: _width / 3,
                                      height: _height / 20,
                                      decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(_height / 40),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black87,
                                            blurRadius: 2.0,
                                            offset: Offset(0.0, 1.0),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'EDIT',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image(
                                    image:
                                        AssetImage('assets/images/prooof.jpg'))
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? newName = userDocument!['firstname'];
    String? newNameName = userDocument!['lastname'];
    String? newEmail = userDocument!['email'];
    String? newPhone = userDocument!['phonenumber'];
    String? address = userDocument!['address'];
    String? date = userDocument!['birthdate'];
    String? newpassword = userDocument!['password'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    initialValue: newName,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                    ),
                    onSaved: (value) => newName = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a first name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: newNameName,
                    decoration: InputDecoration(labelText: 'Last Name'),
                    onSaved: (value) => newNameName = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a last name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: newEmail,
                    decoration: InputDecoration(labelText: 'Email'),
                    onSaved: (value) => newEmail = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: newPhone,
                    decoration: InputDecoration(labelText: 'Phone'),
                    onSaved: (value) => newPhone = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: date,
                    decoration: InputDecoration(labelText: 'Birthday'),
                    onSaved: (value) => date = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a birthday';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: address,
                    decoration: InputDecoration(labelText: 'Address'),
                    onSaved: (value) => address = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: newpassword,
                    decoration: InputDecoration(labelText: 'New Password'),
                    onSaved: (value) => newpassword = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  updateUserData({
                    'firstname': newName!,
                    'lastname': newNameName!,
                    'email': newEmail!,
                    'phonenumber': newPhone!,
                    'birthdate': date!,
                    'address': address!,
                    'password': newpassword,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget headerChild(String header, int value) => Expanded(
        child: Column(
          children: <Widget>[
            Text(header),
            SizedBox(height: 8.0),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xFF26CBE6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget infoChild(double width, IconData icon, String data) => Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(width: width / 10),
              Icon(
                icon,
                color: Colors.indigo,
                size: 36.0,
              ),
              SizedBox(width: width / 20),
              Text(
                data,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Playfair'),
              ),
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );
}
