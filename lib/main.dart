import 'package:flutter/material.dart';

void main() {
  runApp(MyCalculatorApp());
}

class MyCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Calculator',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: createMyColor(const Color(0xFFB71C1C)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: createMyColor(const Color(0xFFB71C1C)),
      ),
      home: MyCalculatorScreen(),
    );
  }
}

MaterialColor createMyColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(r, g, b, ds);
  }
  return MaterialColor(color.value, swatch);
}

class MyCalculatorScreen extends StatefulWidget {
  @override
  _MyCalculatorScreenState createState() => _MyCalculatorScreenState();
}

class _MyCalculatorScreenState extends State<MyCalculatorScreen> {
  String display = '';
  String equation = '';
  String fullEquation = '';
  bool reset = false;
  Brightness currentBrightness = Brightness.light;
  Color backgroundColor = Colors.white;
  Color appBarColor = Colors.red[900]!;
  bool afterResult = false;
  Color displayColor = Colors.black;

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        display = '';
        equation = '';
        fullEquation = '';
      } else if (buttonText == '=') {
        try {
          String result = MyContextModel().calculate(equation);
          display = result.contains('.') ? result : int.parse(result).toString();
          fullEquation = '$equation = $result';
          equation = result;
          reset = true;
          afterResult = true;
        } catch (e) {
          _showError(e.toString());
        }
      } else {
        if (reset) {
          display = '';
          reset = false;
        }
        if (afterResult && '+-×/'.contains(buttonText)) {
          equation += buttonText;
          fullEquation += buttonText;
          afterResult = false;
        } else if (afterResult && !'+-×/'.contains(buttonText)) {
          display = buttonText;
          equation = buttonText;
          fullEquation += buttonText;
          afterResult = false;
        } else {
          display += buttonText;
          equation += buttonText;
          fullEquation += buttonText;
        }
      }
    });
  }

  void toggleTheme() {
    setState(() {
      if (currentBrightness == Brightness.dark) {
        currentBrightness = Brightness.light;
        backgroundColor = Colors.white;
        appBarColor = Colors.red[900]!;
        displayColor = Colors.black;
      } else {
        currentBrightness = Brightness.dark;
        backgroundColor = Colors.black;
        appBarColor = Colors.black;
        displayColor = Colors.white;
      }
    });
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(
            message,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, elevation: 5),
            ),
          ],
        );
      },
    );
  }

  Widget buildButton(String buttonText, Color buttonColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(24.0)),
            backgroundColor: MaterialStateProperty.all(buttonColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: const BorderSide(color: Colors.black, width: 2.0)),
            ),
            elevation: MaterialStateProperty.all<double>(5),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) => states.contains(MaterialState.pressed) ? buttonColor.withOpacity(0.8) : buttonColor,
            ),
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: displayColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kalkulator - Wiktora',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: Icon(currentBrightness == Brightness.dark ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                alignment: Alignment.bottomRight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red[900]!, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      fullEquation,
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.grey[600]!),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        display.isEmpty ? '0' : display,
                        style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: displayColor),
                      ),
                    ),
                    Container(height: 5, width: double.infinity, color: Colors.red[900]!),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      buildButton('7', Colors.red[900]!),
                      buildButton('8', Colors.red[900]!),
                      buildButton('9', Colors.red[900]!),
                      buildButton('/', Colors.orange),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      buildButton('4', Colors.red[900]!),
                      buildButton('5', Colors.red[900]!),
                      buildButton('6', Colors.red[900]!),
                      buildButton('×', Colors.orange),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      buildButton('1', Colors.red[900]!),
                      buildButton('2', Colors.red[900]!),
                      buildButton('3', Colors.red[900]!),
                      buildButton('-', Colors.orange),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      buildButton('C', Colors.blue),
                      buildButton('0', Colors.red[900]!),
                      buildButton('=', Colors.blue),
                      buildButton('+', Colors.orange),
                    ],
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

class MyContextModel {
  String calculate(String equation) {
    List<String> operators = ['+', '-', '×', '/'];

    equation = equation.replaceAll(' ', '');
    equation = equation.replaceAll('=', '');

    List<String> parts = [];
    String currentString = '';

    for (int i = 0; i < equation.length; i++) {
      if (operators.contains(equation[i])) {
        parts.add(currentString);
        parts.add(equation[i]);
        currentString = '';
      } else {
        currentString += equation[i];
      }
    }
    parts.add(currentString);

    double result = double.tryParse(parts[0]) ?? 0;

    for (int i = 1; i < parts.length; i += 2) {
      String operator = parts[i];
      double operand = double.tryParse(parts[i + 1]) ?? 0;

      if (operator == '+') {
        result += operand;
      } else if (operator == '-') {
        result -= operand;
      } else if (operator == '×') {
        result *= operand;
      } else if (operator == '/') {
        if (operand != 0) {
          result /= operand;
        } else {
          throw Exception('Nie dzieli sie przez zero bo basen wybuchnie');
        }
      }
    }

    String resultString = result.toString();
    if (result % 1 == 0) {
      return result.toInt().toString();
    } else {
      return double.parse(resultString).toStringAsFixed(3);
    }
  }
}
