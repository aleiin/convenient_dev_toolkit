import 'package:decimal/decimal.dart';

extension StringEx on String {
  /// 是否是8-30位数字
  bool isContains8To30Digits() {
    int length = this.length;

    if (length >= 8 && length <= 30) {
      return true;
    }

    return false;
  }

  /// 是否有一个数字
  bool isContainsOneNumber() {
    RegExp regExp = RegExp(r'[0-9]');
    bool result = regExp.hasMatch(this);
    return result;
  }

  /// 是否包含小写
  bool isContainsLowercase() {
    /// 匹配小写
    RegExp regExpLower = RegExp(r'[a-z]');

    /// 校验是否有小写字母
    bool result = regExpLower.hasMatch(this);

    return result;
  }

  /// 是否包含大写
  bool isContainsUppercase() {
    /// 匹配大写
    RegExp regExpUpper = RegExp(r'[A-Z]');

    /// 校验是否有大写字母
    bool result = regExpUpper.hasMatch(this);

    return result;
  }

  /// 是否同时包含大写和小写
  bool isContainsUppercaseAndLowercase() {
    bool result = isContainsLowercase() && isContainsUppercase();

    return result;
  }

  /// 是否全是数字
  bool isAllNumbers() {
    RegExp regex = RegExp(r'^[0-9]+$');
    bool result = regex.hasMatch(this);

    return result;
  }

  /// 是否是科学计数法
  bool isScientificNotation() {
    final trimmed = trim();

    final RegExp scientificRegex = RegExp(
      r'^[+\-]?\d*\.?\d+[eE][+\-]?\d+$',
      caseSensitive: false,
    );

    return scientificRegex.hasMatch(trimmed);
  }

  /// 货币格式化
  String toCurrencyFormatter({String delimiter = ','}) {
    String trimmed = trim();

    /// 去除两边的空格
    if (trimmed.isEmpty) {
      return this;
    }

    /// 是否包含科学计数法
    if (isScientificNotation()) {
      final Decimal? parse = Decimal.tryParse(trimmed);

      if (parse != null) {
        trimmed = parse.toString();
      } else {
        return this;
      }
    }

    /// 1. 判断是否合法：可选 +/-/空格 + 任意非数字前缀 + 数字（可含小数点）
    /// 前缀部分：允许除了数字、点、逗号以外的字符（包括货币符号、中文、日文等）
    final RegExp validRegex = RegExp(
      r'^[+\-\s]*[^0-9+\-]*[0-9]+(?:\.[0-9]+)?$',
    );

    if (!validRegex.hasMatch(trimmed)) {
      /// 防止1996.66.66
      return this;
    }

    /// 2. 分离「前缀」和「纯数字部分」
    /// 前缀 = 开头的非数字部分（包括符号、空格）
    /// 数字部分 = 剩下的数字 + 可选小数
    final match = RegExp(r'^([+\-\s]*[^0-9+\-]*)([0-9]+(?:\.[0-9]+)?)$')
        .firstMatch(trimmed);

    if (match == null) {
      return this;
    }

    /// 前缀（可能含货币符号、-B/.、空格等）
    final String prefix = match.group(1) ?? '';

    /// 纯数字字符串，如 "1996.66"
    final String numberStr = match.group(2) ?? '';

    /// 小数点的位置
    int decimalIndex = numberStr.indexOf('.');

    /// 小数部分
    String decimalStr = '';

    /// 整数部分
    String integerStr = '';

    if (decimalIndex == -1) {
      /// 没有小数点
      integerStr = numberStr;
    } else {
      /// 有小数点
      integerStr = numberStr.substring(0, decimalIndex);
      decimalStr = numberStr.substring(decimalIndex, numberStr.length);
    }

    /// 判断是否是0开头
    if (integerStr.length > 1 && integerStr.startsWith('0')) {
      integerStr = integerStr.replaceFirst("0", '');
    }

    /// 格式化
    integerStr =
        integerStr.replaceAll(RegExp(r'(?!^)(?=(\d{3})+$)'), delimiter);

    return prefix + integerStr + decimalStr;
  }
}
