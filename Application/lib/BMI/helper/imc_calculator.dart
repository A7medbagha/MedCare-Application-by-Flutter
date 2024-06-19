import 'dart:math';

class ImcCalculator {
  int peso = 50;
  int altura = 160;
  int idade = 20;
  double imc = 0.0;

  double calculaImc() {
    imc = peso / pow(altura / 100, 2);
    if (imc != 0) {
      return imc;
    } else {
      return 0;
    }
  }

  Male() {
    if (imc != 0) {
      if (imc < 20) {
        return 'You are underweight; try to eat more';
      } else if (imc >= 20 && imc <= 24.9) {
        return 'Excellent! Your weight is normal; keep it that way';
      } else if (imc >= 25 && imc <= 29.9) {
        return 'You are slightly overweight; try to exercise more';
      } else if (imc >= 30 && imc <= 39.9) {
        return 'Attention! You are overweight; consult a nutritionist';
      } else if (imc > 43) {
        return 'Caution! Your weight is significantly above normal; consult a doctor immediately';
      }
    }
  }

  Female() {
    if (imc != 0) {
      if (imc < 20) {
        return 'You are underweight; try to eat more';
      } else if (imc >= 19 && imc <= 23.9) {
        return 'Excellent! Your weight is normal; keep it that way';
      } else if (imc >= 24 && imc <= 28.9) {
        return 'You are slightly overweight; try to exercise more';
      } else if (imc >= 23 && imc <= 38.9) {
        return 'Attention! You are overweight; consult a nutritionist';
      } else if (imc > 39) {
        return 'Caution! Your weight is significantly above normal; consult a doctor immediately';
      }
    }
  }
}
