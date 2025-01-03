import 'package:flutter/material.dart';

/// 修改下划线自定义
class TabIndicator extends Decoration {
  const TabIndicator({
    // 设置下标高度、颜色
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.tabController,
    this.indicatorBottom = 0.0,
    this.indicatorWidth = 4,
    this.indicatorHeight = 4,
  });

  ///
  final TabController? tabController;

  /// 调整指示器下边距
  final double indicatorBottom;

  /// 指示器宽度
  final double indicatorWidth;

  /// 指示器高度
  final double indicatorHeight;

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(
      decoration: this,
      onChanged: onChanged,
      animation: tabController?.animation,
      indicatorWidth: indicatorWidth,
      indicatorHeight: indicatorHeight,
    );
  }

  Rect _indicatorRectFor(Rect indicator, TextDirection textDirection) {
    /// 自定义固定宽度
    double w = indicatorWidth;

    /// 中间坐标
    double centerWidth = (indicator.left + indicator.right) / 2;

    return Rect.fromLTWH(
      /// 距离左边距
      tabController?.animation == null ? centerWidth - w / 2 : centerWidth - 1,

      /// 距离上边距
      indicator.bottom - borderSide.width - indicatorBottom,
      w,
      borderSide.width,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  final TabIndicator decoration;
  Animation<double>? animation;
  double indicatorWidth;
  double indicatorHeight;

  _UnderlinePainter({
    required this.decoration,
    VoidCallback? onChanged,
    this.animation,
    required this.indicatorWidth,
    required this.indicatorHeight,
  }) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    // 以offset坐标为左上角 size为宽高的矩形
    final Rect rect = offset & configuration.size!;

    final TextDirection textDirection = configuration.textDirection!;

    // 返回tab矩形
    final Rect indicator = decoration._indicatorRectFor(rect, textDirection)
      ..deflate(decoration.borderSide.width / 2.0);

    // 圆角画笔
    final Paint paint = decoration.borderSide.toPaint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    if (animation != null) {
      num x = animation!.value; // 变化速度 0-0.5-1-1.5-2...
      num d = x - x.truncate(); // 获取这个数字的小数部分
      num? y;
      if (d < 0.5) {
        y = 2 * d;
      } else if (d > 0.5) {
        y = 1 - 2 * (d - 0.5);
      } else {
        y = 1;
      }
      canvas.drawRRect(
        RRect.fromRectXY(
          Rect.fromCenter(
            center: indicator.centerLeft,
            // 这里控制最长为多长
            width: indicatorWidth * y + indicatorWidth,
            height: indicatorHeight,
          ),
          // 圆角
          2,
          2,
        ),
        paint,
      );
    } else {
      canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
    }
  }
}
