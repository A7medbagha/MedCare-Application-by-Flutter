import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalapp/ADMIN/Dashboard.dart';

class users extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();

  static indexOf(user) {}

  static map(DataRow Function(dynamic user) param0) {}
}

class _SignUpState extends State<users> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => DashboardPage()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashboardPage()));
            },
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo[900],
          title: Text(
            'Patients Informations',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Mobile_Users')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var users = snapshot.data!.docs;
              return SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DataTable(
                    headingRowHeight: 40,
                    dataRowHeight: 60,
                    columnSpacing: 20.0,
                    dividerThickness: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    columns: [
                      DataColumn(
                        label: Text(
                          'First Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Last Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Birth Date',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows: users.map((user) {
                      var userData = user.data() as Map<String, dynamic>;
                      return DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return users.indexOf(user) % 2 == 0
                                ? Colors.grey.withOpacity(0.1)
                                : null;
                          },
                        ),
                        cells: [
                          DataCell(Text(
                            userData['firstname'] ?? '',
                            style: TextStyle(fontSize: 17),
                          )),
                          DataCell(Text(
                            userData['lastname'] ?? '',
                            style: TextStyle(fontSize: 17),
                          )),
                          DataCell(Text(
                            userData['email'] ?? '',
                            style: TextStyle(fontSize: 17),
                          )),
                          DataCell(Text(
                            userData['password'] ?? '',
                            style: TextStyle(fontSize: 17),
                          )),
                          DataCell(Text(
                            userData['birthdate'] ?? '',
                            style: TextStyle(fontSize: 17),
                          )),
                          DataCell(Text(
                            userData['phonenumber'] ?? '',
                            style: TextStyle(fontSize: 17),
                          )),
                          DataCell(Text(
                            userData['address'] ?? '',
                            style: TextStyle(fontSize: 17),
                          )),
                          DataCell(Text(
                            userData['gender'] ?? '',
                            style: TextStyle(fontSize: 17),
                          )),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteUser(context, user.id);
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _deleteUser(BuildContext context, String userId) {
    FirebaseFirestore.instance
        .collection('Mobile_Users')
        .doc(userId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User deleted successfully!'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete user: $error'),
        ),
      );
    });
  }
}
