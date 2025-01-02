import 'package:convenient_dev_toolkit/convenient_dev_toolkit.dart';
import 'package:example/custom_widget.dart';
import 'package:flutter/material.dart';

class PhoneInputTest extends StatefulWidget {
  const PhoneInputTest({Key? key}) : super(key: key);

  @override
  State<PhoneInputTest> createState() => _PhoneInputTestState();
}

class _PhoneInputTestState extends State<PhoneInputTest> {
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
                  // decimal: true,
                  ),
              inputFormatters: [
                PhoneTextInputFormatter(
                  maxLength: 7,
                  masks: ['####@####', '####-#####'],
                  // masks: ['## ### ####'],
                  // masks: ['(###) ### ####'],
                  // masks: [
                  //   '(###) ###-####',
                  //   '#########',
                  //   '##@#####---####',
                  //   '##@###*****##---#####',
                  //   '###--###',
                  //   '###-####',
                  //   '####-####',
                  // ],
                  // masks: [
                  //   '#####',
                  //   '#####-##',
                  //   '#####-###',
                  //   '######-###',
                  //   '######-######',
                  // ],
                ),
              ],
              controller: controller,
              decoration: const InputDecoration(
                hintText: '####@####' ',' '####-#####',
              ),
              onChanged: (value) {
                setState(() {});
                // if (value.isEmpty) {
                //   return;
                // }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  '仅数字的字符串: ${PhoneTextInputFormatter.getOnlyNumbers(controller.text)}'),
            ),
          ],
        ),
      ),
    );
  }
}
