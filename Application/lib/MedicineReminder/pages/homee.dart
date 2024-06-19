import 'package:flutter/material.dart';
import 'package:hospitalapp/MedicineReminder/constants.dart';
import 'package:hospitalapp/MedicineReminder/global_bloc.dart';
import 'package:hospitalapp/MedicineReminder/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class addMedicine extends StatefulWidget {
  const addMedicine({Key? key}) : super(key: key);

  @override
  State<addMedicine> createState() => _MyAppState();
}

class _MyAppState extends State<addMedicine> {
  GlobalBloc? globalBloc;

  @override
  void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value: globalBloc!,
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Pill Reminder',
          theme: ThemeData.dark().copyWith(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: kScaffoldColor,
            appBarTheme: AppBarTheme(
              toolbarHeight: 7.h,
              backgroundColor: kScaffoldColor,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: Colors.black,
                size: 20,
              ),
              titleTextStyle: const TextStyle(
                color: kTextColor,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            textTheme: TextTheme(
              headline3: TextStyle(
                fontSize: 28,
                color: kSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
              headline4: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: kTextColor,
              ),
              headline5: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: kTextColor,
              ),
              headline6: TextStyle(
                fontSize: 13,
                color: kTextColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
              subtitle1: TextStyle(fontSize: 15, color: kPrimaryColor),
              subtitle2: TextStyle(fontSize: 12, color: kTextLightColor),
              caption: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w400,
                color: kTextLightColor,
              ),
              labelMedium: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: kTextColor,
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kTextLightColor,
                  width: 0.7,
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: kTextLightColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor),
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: kScaffoldColor,
              hourMinuteColor: kTextColor,
              hourMinuteTextColor: kScaffoldColor,
              dayPeriodColor: kTextColor,
              dayPeriodTextColor: kScaffoldColor,
              dialBackgroundColor: kTextColor,
              dialHandColor: kPrimaryColor,
              dialTextColor: kScaffoldColor,
              entryModeIconColor: kOtherColor,
              dayPeriodTextStyle: const TextStyle(fontSize: 8),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: MedHomePage(),
        );
      }),
    );
  }
}
