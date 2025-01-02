import 'package:convenient_dev_toolkit/convenient_dev_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Counter increments smoke test', () async {
    final formatter = CurrencyTextInputFormatter();

    // 测试输入数字
    var result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(text: '0.12'),
    );

    expect(result.text, '0.12');

    // 测试输入非数字
    result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(text: '--123abc'),
    );
    expect(result.text, '123');

    // 测试输入非数字
    result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(text: '.123'),
    );
    expect(result.text, '0.123');
  });
}
