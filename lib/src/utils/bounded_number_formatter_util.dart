import 'package:flutter/services.dart';

class BoundedNumberFormatter extends TextInputFormatter {
  final int min;
  final int max;

  BoundedNumberFormatter({
    this.min = 0,
    this.max = 100,
  });

  /// 辅助函数：去除前导 0
  String removeLeadingZeros(String text) {
    if (text.isEmpty) return '0'; // 防空，但实际已检查
    String trimmed = text.replaceAll(RegExp(r'^0+'), ''); // 去除开头的连续 0
    return trimmed.isEmpty ? '0' : trimmed; // 如果全 0，保持 '0'
  }

  /// 辅助函数：创建带光标位置的 TextEditingValue
  TextEditingValue createValueWithCursor(
    String newText,
    TextEditingValue oldValue,
  ) {
    return oldValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length), // 光标置于末尾
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    /// 步骤1: 不允许空输入
    if (newValue.text.isEmpty) {
      return newValue; // 保持上一个有效值
    }

    /// 步骤2: 只允许数字（相当于 digitsOnly 的正则 ^[0-9]*$）
    if (!RegExp(r'^[0-9]*$').hasMatch(newValue.text)) {
      return oldValue; // 非数字，回退
    }

    /// 步骤3: 自动去除前导 0（例如 "01" → "1"）
    String processedText = removeLeadingZeros(newValue.text);
    if (processedText != newValue.text) {
      return createValueWithCursor(processedText, newValue); // 自动修正并调整光标
    }

    /// 步骤4: 范围检查（使用修正后的文本）
    final int? value = int.tryParse(processedText);
    if (value == null) {
      return oldValue; // 无法解析，回退（虽已过滤，但以防）
    }
    if (value < min) {
      return createValueWithCursor(min.toString(), newValue); // 设置为最小值 0，并调整光标
    } else if (value > max) {
      return oldValue; // 超出最大值，回退到旧值
    }

    return newValue; // 全部通过
  }
}
