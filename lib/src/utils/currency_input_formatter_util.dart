import 'package:flutter/services.dart';

/// 货币输入格式化
class CurrencyTextInputFormatter extends TextInputFormatter {
  CurrencyTextInputFormatter({
    this.mantissaLength,
  });

  /// 小数点之后的精度
  final int? mantissaLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String value = newValue.text;

    int selectionIndex = newValue.selection.end;

    /// 替换除小数点之外的字符串
    value = value.replaceAll(RegExp(r'[^.\d]'), '');

    /// 小数点的数量
    int decimalPointCount = RegExp(r"\.").allMatches(value).length;

    /// 如果有2个以上而且不等于0.1开头
    if (decimalPointCount > 1) {
      /// 如果有2个以上

      int firstDotIndex = value.indexOf(".");

      int secondDotIndex = value.indexOf(".", firstDotIndex + 1);

      if (secondDotIndex != -1) {
        value = value.substring(0, secondDotIndex);

        selectionIndex = value.length;
      }
    }

    if (value.startsWith('-')) {
      value = '';
      selectionIndex = 0;
    } else if (value == ".") {
      value = "0.";
      selectionIndex = value.length;
    } else if (value == "-.") {
      value = "-0.";
      selectionIndex = value.length;
    } else if (RegExp(r'^\.').hasMatch(value)) {
      /// 判断是否以小数点开头, 出现类似情况: .12345, 则在这之前加0, 将其格式化为:0.12345
      value = '0$value';
      selectionIndex = value.length;
    } else if (value.isNotEmpty &&
        value.length > 1 &&
        value.startsWith(RegExp(r'0\d+'))) {
      /// 出现情况类似于: 01234.123 的情况, 直接将开头的0干掉

      /// 从开头找到第一个非零数字的下标
      int nonZeroIndexOf = value.indexOf(RegExp(r'[^0]'));

      if (nonZeroIndexOf != -1) {
        value = value.substring(nonZeroIndexOf);

        /// 格式化之后找到第一个小数点的位置
        int firstDotIndex = value.indexOf(".");

        if (value.startsWith('.')) {
          /// 防止情况: 000.12345, 经过截取之后只剩下.12345, 需要手动添加0, 格式化成: 0.12345
          /// 第二种情况: 00., 截取之后只剩[.], 需要手动添加0, 格式化成: 0.
          value = '0$value';
          selectionIndex = value.length;
        } else if (firstDotIndex < newValue.selection.end) {
          /// 格式化之后, 如果最新值的光标大于小数点所在的位置,就手动格式化光标的位置,将光标移动至小数点之前
          selectionIndex = firstDotIndex;
        }
      } else {
        /// 防止情况: 00, 则直接格式化为0
        value = '0';
        selectionIndex = value.length;
      }
    }

    if (value.contains('.') && mantissaLength != null) {
      /// 寻找小数点的长度
      int indexOf = value.indexOf('.');

      /// 找到了小数点
      if (indexOf != -1) {
        /// 从开头到小数点的长度
        int indexOfLeftLength = value.substring(0, indexOf + 1).length;

        /// 小数点之后的长度
        int subLength = value.substring(indexOf + 1).length;

        if (subLength > mantissaLength!) {
          /// 截取从开头到小数点后几位的字符串
          value = value.substring(0, indexOfLeftLength + mantissaLength!);

          /// 截取之后的长度
          int valueLength = value.length;

          /// 旧光标最后的位置
          int oldSelectionEnd = oldValue.selection.end;

          /// 新光标最后的位置
          int newSelectionEnd = newValue.selection.end;

          if (oldSelectionEnd > valueLength) {
            /// 防止情况: 通过外部给text赋值之后, 赋值的精度超过指定的精度, 重新给输入框输入值, 上一次的光标长度大于截取之后的长度则去截取之后的长度
            selectionIndex = valueLength;
          } else if (oldSelectionEnd == 0) {
            /// 防止情况: 输入框没值, 直接粘贴进一个超过最后精度的小数, 光标位置直接取截取之后的长度
            selectionIndex = valueLength;
          } else if (newSelectionEnd > valueLength) {
            /// 防止情况: 正常输入, 因为截取的问题, 最新的光标位置会比之前的大, 当光标的位置大于字符串的长度的时候, 直接取字符串的长度
            selectionIndex = valueLength;
          } else {
            /// 其他情况下都是去最新的位置
            selectionIndex = newValue.selection.end;
          }
        }
      }
    }

    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
