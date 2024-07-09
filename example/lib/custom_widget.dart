import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomWidget extends StatefulWidget {
  const CustomWidget({
    Key? key,
    this.isCustomAppBar = true,
    this.appBar,
    this.leading,
    this.title,
    this.backgroundColor,
    this.iconTheme,
    this.elevation = 0,
    this.titleLabel = '标题',
    this.titleLabelStyle,
    this.automaticallyImplyLeading = true,
    this.body,
    this.actions,
    this.endDrawer,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.systemOverlayStyle,
    this.centerTitle = true,
  }) : super(key: key);

  /// 是否使用自定义的appBar
  final bool isCustomAppBar;

  ///
  final PreferredSizeWidget? appBar;

  ///
  final Widget? leading;

  ///
  final Widget? title;

  ///
  final Color? backgroundColor;

  ///
  final IconThemeData? iconTheme;

  ///
  final double? elevation;

  ///
  final String titleLabel;

  ///
  final TextStyle? titleLabelStyle;

  ///
  final bool automaticallyImplyLeading;

  ///
  final Widget? body;

  ///
  final List<Widget>? actions;

  ///
  final Widget? endDrawer;

  ///
  final Widget? bottomNavigationBar;

  ///
  final bool resizeToAvoidBottomInset;

  ///
  final SystemUiOverlayStyle? systemOverlayStyle;

  ///
  final bool centerTitle;

  @override
  State<CustomWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isCustomAppBar
          ? AppBar(
              leading: widget.leading,
              title: widget.title ??
                  Text(
                    widget.titleLabel,
                    style: widget.titleLabelStyle,
                  ),
              automaticallyImplyLeading: widget.automaticallyImplyLeading,
              actions: widget.actions,
              backgroundColor: widget.backgroundColor,
              iconTheme: widget.iconTheme,
              elevation: widget.elevation,
              systemOverlayStyle:
                  widget.systemOverlayStyle ?? SystemUiOverlayStyle.dark,
              centerTitle: widget.centerTitle,
            )
          : widget.appBar,
      body: widget.body,
      endDrawer: widget.endDrawer,
      bottomNavigationBar: widget.bottomNavigationBar,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
    );
  }
}
