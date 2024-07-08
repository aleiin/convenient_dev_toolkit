import 'package:flutter/services.dart';

/// 整数输入格式化
class IntegerTextInputFormatter extends TextInputFormatter {
  IntegerTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String value = newValue.text;

    int selectionIndex = newValue.selection.end;

    if (value.isNotEmpty &&
        value.length > 1 &&
        value.startsWith(RegExp(r'0\d+'))) {
      /// 出现情况类似于: 01234 的情况, 直接将开头的0干掉, 将其格式化为1234

      /// 从末尾找到第一个非数字字符的位置
      int lastIndexOf = value.lastIndexOf(RegExp(r'[^0-9]'));

      if (lastIndexOf != -1) {
        /// 防止情况: 00.0.0000123456, 则从尾部开始找到数字部分
        value = value.substring(lastIndexOf + 1);
      }

      /// 从开头找到第一个非零数字的下标
      int indexOf = value.indexOf(RegExp(r'[^0]'));

      if (indexOf != -1) {
        /// 防止情况: 000000123, 则从开头找到非0的下标,并截取出来
        value = value.substring(indexOf);
      } else {
        value = '0';
      }

      selectionIndex = value.length;
    }

    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
