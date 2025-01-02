import 'package:convenient_dev_toolkit/convenient_dev_toolkit.dart';
import 'package:example/custom_widget.dart';
import 'package:flutter/material.dart';

class CurrencyInputTest extends StatefulWidget {
  const CurrencyInputTest({Key? key}) : super(key: key);

  @override
  State<CurrencyInputTest> createState() => _CurrencyInputTestState();
}

class _CurrencyInputTestState extends State<CurrencyInputTest> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomWidget(
      titleLabel: '电话号码输入框测试',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              // padding: EdgeInsets.zero,
              // isTitle: false,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                CurrencyTextInputFormatter(),
              ],
              controller: controller,
              decoration: const InputDecoration(hintText: ''),
            ),
          ],
        ),
      ),
    );
  }
}
