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
    // 1. 大数字 + 不同小数位
    '999999999.123456', // → 999,999,999.123456
    '999999999.4567', // → 999,999,999.4567
    '1234567890.12345', // → 1,234,567,890.12345
    '987654321.9876543', // → 987,654,321.987654     （超过6位会四舍五入或截断，实际intl按规则处理）

    // 2. 小数位数测试
    '10.9', // → 10.9
    '10.92', // → 10.92
    '10.924', // → 10.924
    '10.925', // → 10.925
    '10.9256', // → 10.9256
    '10.92567', // → 10.92567
    '10.925678', // → 10.925678
    '10.9256789', // → 10.925679           （第7位四舍五入）

    // 3. 整数与零值
    '2', // → 2
    '0', // → 0
    '0.0', // → 0
    '0.00', // → 0
    '123.00000', // → 123
    '1234.00000', // → 1,234
    '1000000.000000', // → 1,000,000

    // 4. 极小数值
    '0.0039', // → 0.0039
    '0.0000000014', // → 0                    （小于6位有效小数时被视为0）
    '0.00000001', // → 0
    '0.0000014', // → 0.000001             （保留有效位）

    // 5. 带前缀符号
    '+0.0000000014', // → +0
    '+1234567.0000000014', // → +1,234,567
    '-1234567.89', // → -1,234,567.89
    '+\$ 9999.99', // → +$ 9,999.99
    '+\$              & 9999.99', // → +$ 9,999.99
    '-B/. 1996.66', // → -B/. 1,996.66
    '¥123456789.123', // → ¥123,456,789.123

    // 6. 不合法或特殊情况（应原样返回）
    '1e-8', // → 1e-8                 （科学计数法，不合法）
    '+2.5E+3', //
    '-0.001e10', //
    '.5e-4', //
    '123.00000.1', // → 123.00000.1          （多个小数点）
    'abc123.45', // → abc123.45
    '123.45.67', // → 123.45.67
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
