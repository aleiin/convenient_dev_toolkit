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

  /// *********************************************
  /// 需求
  /// *********************************************

  /// 价格小于1，保留小数点后面的8位数：如：0.00390000；0.00000001
  /// 价格大于等于1，保留两位小数：如：10.92、9.80；1.00
  /// 价格等于0,则显示为：0.00
  ///
  /// token：保留精度8位小数；如：123.12345678；0.12345678
  /// 若末位为0则隐藏0，如：123.15678900=123.156789；123.00100=123.001
  /// 如果为0, 则显示为: 0
  /// 如果为2, 则显示为: 2

  /// token用
  ///
  /// 处理货币格式化和保留小数点后几位
  /// isRemoveEndZero: 是否删除末尾的0, 假设保留8位小数, 现有小数: 0.123450, isRemoveEndZero为true的情况下, 则格式化为: 0.12345, 如果为false,则格式化为0.12345000
  /// isCurrencyFormatter: 是否启用货币格式化
  String toCurrencyFormatFractionDigits({
    int fractionDigits = 8,
    bool isRemoveEndZero = true,

    /// 是否启用货币格式化
    bool isCurrencyFormatter = true,
  }) {
    /// 是否有加号
    bool isAddition = false;

    if (length > 1) {
      isAddition = substring(0, 1).contains('+');
    }

    /// 结果
    String result = this;

    ///
    final Decimal? parse = Decimal.tryParse(this);

    if (parse != null) {
      /// 保留多少位小数, 四舍五入
      final String strAsFixed = parse.toStringAsFixed(fractionDigits);

      /// 是否删除末尾的0
      /// 123.00100=123.001
      if (isRemoveEndZero) {
        /// 获取保留的小数位之后再从新格式化
        final Decimal? strAsFixedParse = Decimal.tryParse(strAsFixed);

        if (strAsFixedParse != null) {
          result = strAsFixedParse.toString();
        }
      } else {
        result = strAsFixed;
      }
    }

    if (isAddition) {
      result = '+$result';
    }

    if (isCurrencyFormatter) {
      result = result.toCurrencyFormatter();
    }

    return result;
  }

  /// 价格用
  ///
  /// 换算为USDT的价格
  /// 价格 <= 0: 0.00
  /// 0 < 价格 < 1 : 保留小数后8位: 0.00390000 或 0.00000002
  /// 价格 > 1 : 保留两位小数: 10.92 或 9.80 或 1.00
  String toUSDTPrice({
    bool isCurrencyFormatter = true,
  }) {
    /// 是否有加号
    bool isAddition = false;

    if (length > 1) {
      isAddition = substring(0, 1).contains('+');
    }

    /// 结果
    String result = this;

    final Decimal? parse = Decimal.tryParse(this);

    if (parse != null) {
      if (parse.toDouble() < 1.0) {
        /// 保留有效位之后的位数
        if (parse.toDouble() == 0.0) {
          return '0.00';
        } else {
          final String result = parse.toString().toCurrencyFormatFractionDigits(
                fractionDigits: 8,
                isCurrencyFormatter: isCurrencyFormatter,
              );

          final Decimal? resultParse = Decimal.tryParse(result);

          if (resultParse != null) {
            /// 如果四舍五入完还是0.00000000, 那还是返回0.00
            if (resultParse.toDouble() == 0.0) {
              return '0.00';
            } else {
              /// 是否有加号
              if (isAddition) {
                return '+$result';
              }

              return result;
            }
          } else {
            return this;
          }
        }
      } else {
        /// 是否有加号
        if (isAddition) {
          return '+${parse.toString().toCurrencyFormatFractionDigits(
                fractionDigits: 2,
                isCurrencyFormatter: isCurrencyFormatter,
              )}';
        }

        return parse.toString().toCurrencyFormatFractionDigits(
              fractionDigits: 2,
              isCurrencyFormatter: isCurrencyFormatter,
            );
      }
    } else {
      return this;
    }
  }

  /// 保留字母
  String toKeepSymbol() {
    return replaceAll(RegExp(r'[^a-zA-Z]'), '').toUpperCase();
  }
}
