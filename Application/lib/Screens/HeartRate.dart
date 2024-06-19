import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hospitalapp/HomePage/Home.dart';
import 'package:hospitalapp/PATIENTS/LogIN.dart';

class HeartRate extends StatefulWidget {
  const HeartRate({Key? key}) : super(key: key);

  @override
  State<HeartRate> createState() => _HeartRateState();
}

class _HeartRateState extends State<HeartRate> {
  int? bpmValue;
  List<int> savedBPMValues = [];

  @override
  Widget build(BuildContext context) {
    String email = UserCredentials.userEmail;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Heart Rate Monitor',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'playfair'),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
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
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Please cover both the camera and the flash with your finger",
              style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'playfair'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            HeartBPMDialog(
              borderRadius: 30,
              context: context,
              onRawData: (value) {},
              onBPM: (value) {
                setState(() {
                  bpmValue = value;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      bpmValue?.toString() ?? "-",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (bpmValue != null) {
                  setState(() {
                    savedBPMValues.add(bpmValue!);
                    bpmValue = null;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save BPM',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'playfair'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: savedBPMValues.isNotEmpty
                          ? BarChart(
                              BarChartData(
                                titlesData: FlTitlesData(
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (context, value) =>
                                        const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    margin: 16,
                                  ),
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (context, value) =>
                                        const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    margin: 16,
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(color: Colors.grey),
                                ),
                                barGroups:
                                    savedBPMValues.asMap().entries.map((entry) {
                                  return BarChartGroupData(
                                    x: entry.key,
                                    barRods: [
                                      BarChartRodData(
                                        y: entry.value.toDouble(),
                                        colors: [Colors.red],
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            )
                          : Center(
                              child: Text(
                                'No data to display',
                                style: TextStyle(
                                  fontFamily: 'playfair',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 4,
                      child: ListView.builder(
                        itemCount: savedBPMValues.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(savedBPMValues[index].toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {
                                savedBPMValues.removeAt(index);
                              });
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Saved BPM: ${savedBPMValues[index]}',
                                    style: TextStyle(
                                      fontFamily: 'playfair',
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
