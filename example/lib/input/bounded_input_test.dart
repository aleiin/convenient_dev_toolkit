import 'package:convenient_dev_toolkit/convenient_dev_toolkit.dart';
import 'package:example/custom_widget.dart';
import 'package:flutter/material.dart';

class BoundedInputTest extends StatefulWidget {
  const BoundedInputTest({Key? key}) : super(key: key);

  @override
  State<BoundedInputTest> createState() => _BoundedInputTestState();
}

class _BoundedInputTestState extends State<BoundedInputTest> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomWidget(
      titleLabel: '有界数字输入框测试',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              inputFormatters: [
                BoundedNumberFormatter(min: 0, max: 100),
              ],
              controller: controller,
              decoration: const InputDecoration(hintText: '0-100'),
            ),
          ],
        ),
      ),
    );
  }
}
