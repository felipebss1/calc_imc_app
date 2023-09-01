import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMC Calculator',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.lora().fontFamily,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController alturaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();

  double altura = 0;
  double peso = 0;

  bool _isValidNumber(String value) {
    final validCharacters = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

    for (var character in value.runes) {
      final char = String.fromCharCode(character);
      if (!validCharacters.contains(char)) {
        return false;
      }
    }
    return true;
  }

  double calcImc(double altura, double peso) {
    return peso / pow((altura / 100), 2);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headlineMedium;
    const bodyTextStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Calculadora IMC',
            style: GoogleFonts.playfairDisplay(
                textStyle: Theme.of(context).textTheme.displaySmall,
                color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade600,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quer saber qual o seu IMC?',
                  style: titleStyle,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            const Text('Altura(em cm)'),
                            TextFormField(
                              decoration:
                                  const InputDecoration(hintText: '170'),
                              controller: alturaController,
                              keyboardType: TextInputType.number,
                              validator: (altura) {
                                if (altura == null || altura.isEmpty) {
                                  return 'Por favor, insira sua altura.';
                                }
                                if (!_isValidNumber(altura)) {
                                  return 'Insira um número válido.';
                                }
                                return null;
                              },
                              onChanged: (novaAltura) {
                                if (!_isValidNumber(novaAltura)) {
                                  return;
                                }
                                altura = double.tryParse(novaAltura) ?? 0;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          children: [
                            const Text('Peso(em kg)'),
                            TextFormField(
                              decoration: const InputDecoration(hintText: '70'),
                              controller: pesoController,
                              keyboardType: TextInputType.number,
                              validator: (peso) {
                                if (peso == null || peso.isEmpty) {
                                  return 'Por favor, insira seu peso.';
                                }
                                if (!_isValidNumber(peso)) {
                                  return 'Insira um número válido.';
                                }

                                return null;
                              },
                              onChanged: (novoPeso) {
                                if (!_isValidNumber(novoPeso)) {
                                  return;
                                }
                                peso = double.tryParse(novoPeso) ?? 0;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        double resultadoImc = calcImc(altura, peso);
                        String resultadoDescricao = '';
                        double imc = resultadoImc;

                        if (imc < 18.5) {
                          resultadoDescricao = 'Abaixo do peso';
                        } else if (imc >= 18.5 && imc <= 24.9) {
                          resultadoDescricao = 'Peso normal';
                        } else if (imc >= 25.0 && imc <= 29.9) {
                          resultadoDescricao = 'Sobrepeso';
                        } else if (imc >= 30.0 && imc <= 34.9) {
                          resultadoDescricao = 'Obesidade grau I';
                        } else if (imc >= 35.0 && imc <= 39.9) {
                          resultadoDescricao = 'Obesidade grau II';
                        } else if (imc >= 40.0) {
                          resultadoDescricao = 'Obesidade grau III';
                        }

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Resultado do IMC'),
                              content: Text(
                                'Seu IMC é ${resultadoImc.toStringAsFixed(1)}\n\n$resultadoDescricao',
                                style: bodyTextStyle,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    alturaController.clear();
                                    pesoController.clear();
                                  },
                                  child: const Text('Fechar'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      'Calcular IMC',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'O que é IMC?',
                  style: titleStyle,
                ),
                const SizedBox(height: 16),
                const Text(
                  'O índice de massa corporal (IMC) é uma medida de peso corporal em relação à altura. É calculado dividindo-se o peso em quilogramas pelo quadrado da altura em metros. O IMC é uma medida simples e fácil de usar, mas não é perfeito. Ele não leva em consideração a distribuição da gordura corporal, que pode ser mais perigosa em algumas áreas do corpo do que em outras.',
                  style: bodyTextStyle,
                ),
                const SizedBox(height: 16),
                Text(
                  'Recomendações',
                  style: titleStyle,
                ),
                const SizedBox(height: 16),
                const Text(
                  'A OMS recomenda que os adultos busquem um IMC dentro da faixa de peso normal. O IMC abaixo do peso pode estar associado a problemas de saúde, como desnutrição e deficiências de nutrientes. O sobrepeso e a obesidade são fatores de risco para uma série de doenças, incluindo doenças cardíacas, derrame, diabetes tipo 2, alguns tipos de câncer e apneia do sono.',
                  style: bodyTextStyle,
                ),
                const SizedBox(height: 16),
                const Text(
                  'É importante ressaltar que o IMC é apenas um indicador de saúde. Outras medidas, como a circunferência da cintura, também devem ser consideradas para avaliar o risco de doenças relacionadas ao peso.',
                  style: bodyTextStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
