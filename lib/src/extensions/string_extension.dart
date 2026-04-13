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

  /// 货币格式化
  String toCurrencyFormatter({String delimiter = ','}) {
    /// 字符串
    String str = '';

    /// 小数部分
    String decimalStr = '';

    /// 整数部分
    String integerStr = '';

    /// 小数点位置
    int decimalIndex = 0;

    /// 是否有负号
    bool isNegative = false;

    /// 是否有加号
    bool isAddition = false;

    if (length > 1) {
      isNegative = substring(0, 1).contains('-');
      isAddition = substring(0, 1).contains('+');
    }

    final Decimal? parse = Decimal.tryParse(this);

    if (parse != null) {
      /// 干掉除小数之外的字符
      str = replaceAll(RegExp(r'[^.\d]'), '');

      /// 小数点的数量
      int decimalPointCount = RegExp(r"\.").allMatches(str).length;

      /// 大于1个小数点的直接返回, 不做格式化
      if (decimalPointCount > 1) {
        return this;
      }

      /// 如果有一个小数点
      if (decimalPointCount == 1) {
        decimalIndex = str.indexOf('.');

        integerStr = str.substring(0, decimalIndex);
        decimalStr = str.substring(decimalIndex, str.length);
      } else {
        integerStr = str;
      }

      /// 判断是否是0开头
      if (integerStr.length > 1 && integerStr.startsWith('0')) {
        integerStr = integerStr.replaceFirst("0", '');
      }

      /// 格式化
      integerStr =
          integerStr.replaceAll(RegExp(r'(?!^)(?=(\d{3})+$)'), delimiter);

      /// **************************************************
      /// 有小数
      /// **************************************************

      /// 必须是.x格式才可拼接
      if (decimalStr.length > 1) {
        /// 有负号, 拼接负号
        if (isNegative) {
          return '-$integerStr$decimalStr';
        }

        /// 前面有加号, 拼接加号
        if (isAddition) {
          return '+$integerStr$decimalStr';
        }

        return integerStr + decimalStr;
      }

      /// **************************************************
      /// 没有小数
      /// **************************************************

      /// 有负号, 拼接负号
      if (isNegative) {
        return '-$integerStr';
      }

      /// 前面有加号, 拼接加号
      if (isAddition) {
        return '+$integerStr';
      }

      return integerStr;
    } else {
      return this;
    }
  }

  /// 保留字母
  String toKeepSymbol() {
    return replaceAll(RegExp(r'[^a-zA-Z]'), '').toUpperCase();
  }
}
