// import 'dart:math';
//
// import 'package:epowerspot_app/extensions/lang_extension.dart';
// import 'package:epowerspot_app/style/theme_brightness.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// /// 展开和收缩组件
// class ExpandCollapse extends StatefulWidget {
//   const ExpandCollapse({
//     Key? key,
//     this.isTopBorder = true,
//     this.isBottomBorder = true,
//     this.isInit = false,
//     this.label = '标题',
//     this.child,
//   }) : super(key: key);
//
//   ///
//   final bool isTopBorder;
//
//   ///
//   final bool isBottomBorder;
//
//   /// 是否初始化
//   final bool isInit;
//
//   ///
//   final String label;
//
//   ///
//   final Widget? child;
//
//   @override
//   State<ExpandCollapse> createState() => _ExpandCollapseState();
// }
//
// class _ExpandCollapseState extends State<ExpandCollapse>
//     with SingleTickerProviderStateMixin {
//   ///
//   late AnimationController animationController;
//
//   @override
//   void initState() {
//     super.initState();
//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//
//     if (widget.isInit) {
//       animationController.forward();
//     }
//   }
//
//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }
//
//   ///
//   void toggle() {
//     if (animationController.isAnimating) {
//       return;
//     }
//
//     if (animationController.isDismissed) {
//       animationController.forward();
//     } else {
//       animationController.reverse();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Visibility(
//           visible: widget.isTopBorder,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: 1,
//             color: ThemeBrightness.expandCollapseBorder,
//           ),
//         ),
//         InkWell(
//           onTap: toggle,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: Text(
//                     widget.label.tr,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 AnimatedBuilder(
//                   animation: animationController,
//                   builder: (BuildContext context, Widget? child) {
//                     return Transform(
//                       transform: Matrix4.rotationX(
//                         pi * animationController.value,
//                       ),
//                       alignment: Alignment.center,
//                       child: child,
//                     );
//                   },
//                   child: const Icon(Icons.keyboard_arrow_down),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         AnimatedBuilder(
//           animation: animationController,
//           builder: (BuildContext context, Widget? child) {
//             return ClipRect(
//               child: FadeTransition(
//                 opacity: animationController,
//                 child: Align(
//                   alignment: AlignmentDirectional.topCenter,
//                   heightFactor: animationController.value,
//                   child: child,
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.only(bottom: widget.child == null ? 0 : 16),
//             width: MediaQuery.of(context).size.width,
//             child: widget.child,
//           ),
//         ),
//         Visibility(
//           visible: widget.isBottomBorder,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: 1,
//             color: ThemeBrightness.expandCollapseBorder,
//           ),
//         ),
//       ],
//     );
//   }
// }
