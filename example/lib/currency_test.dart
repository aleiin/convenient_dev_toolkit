import 'package:convenient_dev_toolkit/convenient_dev_toolkit.dart';
import 'package:example/custom_widget.dart';
import 'package:flutter/material.dart';

class CurrencyTest extends StatefulWidget {
  const CurrencyTest({Key? key}) : super(key: key);

  @override
  State<CurrencyTest> createState() => _CurrencyTestState();
}

class _CurrencyTestState extends State<CurrencyTest> {
  List<String> price = [
    '999999999.123456',
    '999999999.4567',
    '10.9',
    '10.92',
    '10.924',
    '10.925',
    '2',
    '0.0039',
    '0.0',
    '0',
    '1e-8',
    '123.00000',
    '1234.00000',
    '0.0000000014',
    '0.00000001',
    '+0.0000000014',
    '1234567.0000000014',
    '+1234567.0000000014',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomWidget(
      titleLabel: '币种精度测试',
      actions: [
        IconButton(
          onPressed: () {
            setState(() {});
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '价格',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                ...List.generate(
                  price.length,
                  (index) => getPrice(
                    index: 'p${index + 1}',
                    label: price[index],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getPrice({String index = '0', String label = ''}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(index),
        const SizedBox(width: 20),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(label),
              ),
              Flexible(
                child: Text(
                  label.toCurrencyFormatter(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
