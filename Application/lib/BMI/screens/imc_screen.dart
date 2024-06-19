import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hospitalapp/BMI/helper/gender_enum.dart';
import 'package:hospitalapp/BMI/helper/imc_calculator.dart';
import 'package:hospitalapp/BMI/screens/result.dart';
import 'package:hospitalapp/BMI/widgets/container_aux.dart';
import 'package:hospitalapp/BMI/widgets/container_bottom.dart';
import 'package:hospitalapp/BMI/widgets/container_middle.dart';

class ImcScreen extends StatefulWidget {
  const ImcScreen({Key? key}) : super(key: key);

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

ImcCalculator imc = ImcCalculator();
Gender? selectedGender;
double resultadoImc = 0;
String interpretacao = '';

class _ImcScreenState extends State<ImcScreen> {
  bool isMale = false;
  bool isFemale = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    Offset distanceMale = isMale ? const Offset(10, 10) : const Offset(15, 15);
    double blurMale = isMale ? 5 : 30;
    Offset distanceFemale =
        isFemale ? const Offset(10, 10) : const Offset(15, 15);
    double blurFemale = isFemale ? 5 : 30;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text(
          'BMI CALCULATOR',
          style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //Top
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = Gender.Male;
                          if (selectedGender == Gender.Male) {
                            isMale = !isMale;
                            isFemale = false;
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.indigo,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: blurMale,
                                offset: -distanceMale,
                                color: Colors.white,
                                inset: isMale,
                              ),
                              BoxShadow(
                                blurRadius: blurMale,
                                offset: distanceMale,
                                color: const Color(0xFFA7A9AF),
                                inset: isMale,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 210,
                            height: size.height * .25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.male,
                                  size: 90,
                                  color: Colors.white,
                                ),
                                Text(
                                  'MALE',
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                      child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.Female;
                        if (selectedGender == Gender.Female) {
                          isFemale = !isFemale;
                          isMale = false;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.indigo,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: blurFemale,
                              offset: -distanceFemale,
                              color: Colors.white,
                              inset: isFemale,
                            ),
                            BoxShadow(
                              blurRadius: blurFemale,
                              offset: distanceFemale,
                              color: const Color(0xFFA7A9AF),
                              inset: isFemale,
                            )
                          ],
                        ),
                        child: SizedBox(
                          width: 210,
                          height: size.height * .25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.female, size: 90, color: Colors.white),
                              Text(
                                'FEMALE',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
                ),
              ],
            ),
            ContainerMiddle(
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        imc.altura.toString(),
                        style: const TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      ),
                      const Text(
                        'cm',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: 1.5),
                      ),
                    ],
                  ),
                  Slider(
                      value: imc.altura.toDouble(),
                      min: 120,
                      max: 200,
                      thumbColor: backgroundColor,
                      inactiveColor: Colors.black,
                      activeColor: Colors.white,
                      onChanged: (double novaAltura) {
                        setState(() {
                          imc.altura = novaAltura.round();
                        });
                      })
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContainerBottom(
                  text: 'WEIGHT',
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            imc.peso.toString(),
                            style: const TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5),
                          ),
                          const Text(
                            'kg',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                letterSpacing: 1.5),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                imc.peso--;
                              });
                            },
                            child: ContainerAux(icon: Icons.remove),
                          ),
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                imc.peso++;
                              });
                            },
                            child: ContainerAux(icon: Icons.add),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                ContainerBottom(
                  text: 'AGE',
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            imc.idade.toString(),
                            style: const TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5),
                          ),
                          const Text(
                            ' year',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                letterSpacing: 1.5),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                imc.idade--;
                              });
                            },
                            child: ContainerAux(icon: Icons.remove),
                          ),
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                imc.idade++;
                              });
                            },
                            child: ContainerAux(icon: Icons.add),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Listener(
                onPointerUp: (_) {
                  setState(() {
                    resultadoImc = imc.calculaImc();
                    if (selectedGender != null) {
                      if (selectedGender == Gender.Male) {
                        interpretacao = imc.Male();
                      } else if (selectedGender == Gender.Female) {
                        interpretacao = imc.Female();
                      }
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (contenxt) => Result(),
                      ),
                    );

                    isPressed = false;
                  });
                },
                onPointerDown: (_) {
                  setState(() {
                    isPressed = true;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.indigo,
                      boxShadow: isPressed
                          ? []
                          : [
                              const BoxShadow(
                                blurRadius: 10,
                                offset: Offset(-5, -5),
                                color: Colors.white,
                              ),
                              const BoxShadow(
                                blurRadius: 20,
                                offset: Offset(10, 10),
                                color: Color(0xFFA7A9AF),
                              ),
                            ]),
                  child: const Padding(
                    padding: EdgeInsets.all(13),
                    child: Text(
                      'Calculate BMI',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
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
}

double? get resultado {
  return resultadoImc;
}

String? get interpreta {
  return interpretacao;
}

set setPeso(int novoPeso) {
  imc.peso = novoPeso;
}

set setAltura(int novaAltura) {
  imc.altura = novaAltura;
}

set setIdade(int novaIdade) {
  imc.idade = novaIdade;
}
