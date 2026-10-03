import 'package:flutter/material.dart';
import 'package:calculadora/enums/operation.type.dart';
import 'package:calculadora/widgets/button.widget.dart';
import 'history_page.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String displayNumber = '0';
  List<String> history = [];

  void clear() {
    setState(() {
      displayNumber = '0';
    });
  }

  void appendNumber(String number) {
    setState(() {
      if (displayNumber == '0') {
        displayNumber = number;
      } else {
        displayNumber += number;
      }
    });
  }

  void setOperationType(OperationType type) {
    setState(() {
      displayNumber += type.symbol;
    });
  }

  void calculate() {
    String expression = displayNumber.replaceAll(',', '.');
    List<double> numbers = _parseNumbers(expression);
    List<OperationType> operators = _getOperators(expression);

    if (numbers.isEmpty || operators.isEmpty) return;

    _resolvePriorityOperations(numbers, operators);
    double result = _resolveAdditionAndSubtraction(numbers, operators);

    setState(() {
      String resultStr = result.toString().replaceAll('.', ',');
      if (resultStr.endsWith(',0')) {
        resultStr = resultStr.substring(0, resultStr.length - 2);
      }
      history.add('$displayNumber = $resultStr');
      displayNumber = resultStr;
    });
  }

  List<double> _parseNumbers(String expression) {
    List<double> numbers = [];
    RegExp regex = RegExp(r'\d+(\.\d+)?');
    Iterable<Match> matches = regex.allMatches(expression);
    
    for (Match match in matches) {
      numbers.add(double.parse(match.group(0)!));
    }
    return numbers;
  }

  List<OperationType> _getOperators(String expression) {
    List<OperationType> operators = [];
    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      for (OperationType type in OperationType.values) {
        if (char == type.symbol) {
          operators.add(type);
        }
      }
    }
    return operators;
  }

  void _resolvePriorityOperations(List<double> numbers, List<OperationType> operators) {
    int index = 0;
    while (index < operators.length) {
      if (operators[index] == OperationType.multiplication) {
        numbers[index] = numbers[index] * numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else if (operators[index] == OperationType.division) {
        numbers[index] = numbers[index] / numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else {
        index++;
      }
    }
  }

  double _resolveAdditionAndSubtraction(List<double> numbers, List<OperationType> operators) {
    int index = 0;
    while (index < operators.length) {
      if (operators[index] == OperationType.addition) {
        numbers[0] = numbers[0] + numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else if (operators[index] == OperationType.subtraction) {
        numbers[0] = numbers[0] - numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else {
        index++;
      }
    }
    return numbers[0];
  }

  @override
  Widget build(BuildContext context) {
    final Color operatorColor = Colors.orangeAccent;
    final Color numberColor = Colors.deepPurple[400]!;
    final Color calculateColor = Colors.greenAccent[700]!;
    
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Calculadora', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(history: history),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.black26,
            padding: const EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                displayNumber,
                style: const TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    ButtonWidget(text: 'C', onPressed: clear, color: Colors.redAccent),
                    ButtonWidget(text: '⌫', onPressed: () {
                      if (displayNumber.length > 1) {
                         setState(() { displayNumber = displayNumber.substring(0, displayNumber.length - 1); });
                      } else {
                         clear();
                      }
                    }, color: Colors.redAccent),
                    ButtonWidget(text: OperationType.division.symbol, onPressed: () => setOperationType(OperationType.division), color: operatorColor, textColor: Colors.black87),
                  ],
                ),
                Row(
                  children: [
                    ButtonWidget(text: '7', onPressed: () => appendNumber('7'), color: numberColor),
                    ButtonWidget(text: '8', onPressed: () => appendNumber('8'), color: numberColor),
                    ButtonWidget(text: '9', onPressed: () => appendNumber('9'), color: numberColor),
                    ButtonWidget(text: OperationType.multiplication.symbol, onPressed: () => setOperationType(OperationType.multiplication), color: operatorColor, textColor: Colors.black87),
                  ],
                ),
                Row(
                  children: [
                    ButtonWidget(text: '4', onPressed: () => appendNumber('4'), color: numberColor),
                    ButtonWidget(text: '5', onPressed: () => appendNumber('5'), color: numberColor),
                    ButtonWidget(text: '6', onPressed: () => appendNumber('6'), color: numberColor),
                    ButtonWidget(text: OperationType.subtraction.symbol, onPressed: () => setOperationType(OperationType.subtraction), color: operatorColor, textColor: Colors.black87),
                  ],
                ),
                Row(
                  children: [
                    ButtonWidget(text: '1', onPressed: () => appendNumber('1'), color: numberColor),
                    ButtonWidget(text: '2', onPressed: () => appendNumber('2'), color: numberColor),
                    ButtonWidget(text: '3', onPressed: () => appendNumber('3'), color: numberColor),
                    ButtonWidget(text: OperationType.addition.symbol, onPressed: () => setOperationType(OperationType.addition), color: operatorColor, textColor: Colors.black87),
                  ],
                ),
                Row(
                  children: [
                    ButtonWidget(text: '0', onPressed: () => appendNumber('0'), color: numberColor),
                    ButtonWidget(text: ',', onPressed: () => appendNumber(','), color: numberColor),
                    ButtonWidget(text: '=', onPressed: calculate, color: calculateColor),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}