import 'package:example/currency_test.dart';
import 'package:example/custom_widget.dart';
import 'package:example/input/currency_input_test.dart';
import 'package:example/input/phone_input_test.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomWidget(
      titleLabel: 'debug',
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getItemView(
                  label: '测试',
                  children: [
                    ElevatedButton(
                      child: const Text('电话号码输入框测试'),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const PhoneInputTest();
                        }));
                      },
                    ),
                    ElevatedButton(
                      child: const Text('货币输入框测试'),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const CurrencyInputTest();
                        }));
                      },
                    ),
                    ElevatedButton(
                      child: const Text('币种精度测试'),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const CurrencyTest();
                        }));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getItemView({
    String? label,
    List<Widget> children = const <Widget>[],
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label ?? '',
            style: const TextStyle(fontSize: 20),
          ),
          Wrap(
            spacing: 10,
            children: children,
          ),
        ],
      ),
    );
  }
}
