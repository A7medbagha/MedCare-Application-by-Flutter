import 'package:flutter/material.dart';
import 'package:hospitalapp/Screens/WelcomeScren.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  PageController pageController = PageController();

  List<OnboardingPageModel> onboardingPages = [
    OnboardingPageModel(
      imagePath: 'assets/images/resultsw.png',
      title: 'Results',
      description:
          'Quickly and effortlessly check out your results with simplicity and clarity.',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/appoinw.png',
      title: 'Appointments',
      description:
          'Easily take, adjust, or cancel appointments with simplicity and ease.',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/chatborw.png',
      title: 'Chatbot',
      description:
          'Simply ask about anything you need, from important medications to disease symptoms, and the chatbot will be there to assist you every step of the way.',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/bbbmmm.jpg',
      title: 'BMI Calculator',
      description: 'Use the BMI calculator to monitor your health and fitness.',
    ),
    OnboardingPageModel(
      imagePath: 'assets/images/heartboarding.jpg',
      title: 'Heart Rate Monitor',
      description:
          'Measure your heart rate accurately using the camera and flash.',
    ),
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: onboardingPages.length,
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return buildOnboardingPage(onboardingPages[index]);
                },
              ),
            ),
            buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget buildOnboardingPage(OnboardingPageModel page) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  page.imagePath,
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                SizedBox(height: 35),
                Text(
                  page.title,
                  style: TextStyle(
                    fontSize: 29,
                    fontFamily: 'playfair',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  page.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 19,
                      fontFamily: 'playfair',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
          Positioned(
            top: 35,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen11()),
                );
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.indigo[900],
                  fontFamily: 'playfair',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: currentPage > 0,
            child: ElevatedButton(
              onPressed: () {
                pageController.previousPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[300],
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Previous',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'playfair'),
              ),
            ),
          ),
          Row(
            children: List.generate(
              onboardingPages.length,
              (index) => buildDot(index),
            ),
          ),
          if (currentPage < onboardingPages.length - 1)
            Visibility(
              visible: currentPage < onboardingPages.length - 1,
              child: ElevatedButton(
                onPressed: () {
                  pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo[900],
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'playfair',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          else
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen11()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo[900],
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'playfair',
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 8.0),
      height: 8.0,
      width: currentPage == index ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.indigo : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}

class OnboardingPageModel {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPageModel({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
