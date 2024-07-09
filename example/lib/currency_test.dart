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

  List<String> token = [
    '123.12345678',
    '12345678.12345678',
    '12345678.123456789',
    '0.0039',
    '123.00100',
    '123',
    '-12345678.123456789',
    '+12345678.123456789',
    '1e-8',
    '-1e-8',
    '+1e-8',
    '0',
    '123',
    '1234',
    '+123',
    '+1234',
    '123.00000',
    '1234.00000',
    '1234.00000001',
    '1234.000000012',
    '1234.0000000123',
    '1234.0000000456',
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
                const SizedBox(height: 20),
                const Text(
                  'token',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                ...List.generate(
                  token.length,
                  (index) => getToken(
                    index: 't${index + 1}',
                    label: token[index],
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
                  label.toUSDTPrice(isCurrencyFormatter: true),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getToken({String index = '0', String label = ''}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(index),
        const SizedBox(width: 20),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(label)),
              Flexible(
                child: Text(
                  label.toCurrencyFormatFractionDigits(
                    isRemoveEndZero: true,
                    isCurrencyFormatter: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
