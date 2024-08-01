import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 手机号码输入格式化
class PhoneTextInputFormatter extends TextInputFormatter {
  PhoneTextInputFormatter({
    this.masks,
    this.maxLength,
  });

  /// 格式化内容
  /// ['#### #####', '####-#####']
  final List<String>? masks;

  ///
  final int? maxLength;

  /// 获取仅数字的字符串
  static String getOnlyNumbers(String value) {
    return value.replaceAll(RegExp(r'[^\d]'), '');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    /// 内部维护
    List<String> internalMasks = [...masks ?? []];

    /// 先排序
    internalMasks.sort((l, r) {
      final a = l.replaceAll(RegExp(r'[^#]'), '');
      final b = r.replaceAll(RegExp(r'[^#]'), '');

      return a.length.compareTo(b.length);
    });

    /// 处理掉其他杂乱的字符, 只留下数字
    final String newValueOnlyNumbers =
        newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    /// 为空直接返回
    if (newValueOnlyNumbers.isEmpty) {
      return TextEditingValue(
        text: newValueOnlyNumbers,
        selection: TextSelection.collapsed(offset: newValueOnlyNumbers.length),
      );
    }

    /// 模版不为空则开始处理
    if (internalMasks.isNotEmpty) {
      /// 现在的模版
      String currentMask = internalMasks.first;

      /// 最后一个元素
      final String lastMask = internalMasks.last;

      ///
      currentMask = internalMasks.firstWhere(
        (element) =>
            element.replaceAll(RegExp(r'[^#]'), '').length >=
            newValueOnlyNumbers.length,
        orElse: () => currentMask,
      );

      if (newValueOnlyNumbers.length >
          lastMask.replaceAll(RegExp(r'[^#]'), '').length) {
        currentMask = lastMask;
      }

      for (int j = 0; j < newValueOnlyNumbers.length; j++) {
        currentMask = currentMask.replaceFirst('#', newValueOnlyNumbers[j]);
      }

      /// 找到最后一位数字的位置
      int lastIndex = currentMask.lastIndexOf(RegExp(r'\d'));

      if (lastIndex != -1) {
        /// 截取从开头到最后一位数字的位置
        currentMask = currentMask.substring(0, lastIndex + 1);

        if (newValue.text.length != newValue.selection.end) {
          ///
          /// 从末尾往前减 or /// 从开始往后加
          if ((oldValue.selection.end > newValue.selection.end) ||
              (oldValue.selection.end < newValue.selection.end)) {
            String newSub = newValue.text.substring(0, newValue.selection.end);

            String onlyNum = '';

            for (int i = 0; i < currentMask.length; i++) {
              if (RegExp(r'^[0-9]+$').hasMatch(currentMask[i])) {
                onlyNum = onlyNum + currentMask[i];

                if (onlyNum == newSub.replaceAll(RegExp(r'[^\d]'), '')) {
                  return TextEditingValue(
                    text: currentMask,
                    selection: TextSelection.collapsed(offset: i + 1),
                  );
                }
              }
            }
          }

          return TextEditingValue(
            text: currentMask,
            selection: newValue.selection,
          );
        } else {
          return TextEditingValue(
            text: currentMask,
            selection: TextSelection.collapsed(offset: currentMask.length),
          );
        }
      } else {
        // return newValue;
        return TextEditingValue(
          text: newValueOnlyNumbers,
          selection:
              TextSelection.collapsed(offset: newValueOnlyNumbers.length),
        );
      }
    } else if (maxLength != null) {
      if (maxLength! > 0) {
        // print(
        //     'print 11:18: \n oldValue: ${oldValue.text}, end: ${oldValue.selection.end} \n newValue: ${newValue.text}, end: ${newValue.selection.end}');

        if (newValueOnlyNumbers.characters.length > maxLength!) {
          final String newValueTextSub =
              newValueOnlyNumbers.substring(0, maxLength);

          int selectionIndex = newValueTextSub.length;

          /// 如果光标一直在最末尾,那最新光标一定大于最大长度,如果不大于,就说明光标在中间的某个位置
          if (newValue.selection.end < selectionIndex) {
            selectionIndex = newValue.selection.end;
          }

          return TextEditingValue(
            text: newValueTextSub,
            selection: TextSelection.collapsed(offset: selectionIndex),
          );
        } else {
          return TextEditingValue(
            text: newValueOnlyNumbers,
            selection: TextSelection.collapsed(offset: newValue.selection.end),
          );
        }
      }
    } else {
      int selectionIndex = newValueOnlyNumbers.length;

      /// 如果光标一直在最末尾,那最新光标一定大于最大长度,如果不大于,就说明光标在中间的某个位置
      if (newValue.selection.end < selectionIndex) {
        selectionIndex = newValue.selection.end;
      }

      return TextEditingValue(
        text: newValueOnlyNumbers,
        selection: TextSelection.collapsed(offset: selectionIndex),
      );
    }

    return TextEditingValue(
      text: newValueOnlyNumbers,
      selection: TextSelection.collapsed(offset: newValueOnlyNumbers.length),
    );
  }
}
