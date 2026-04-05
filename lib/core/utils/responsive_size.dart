import 'package:flutter/material.dart';

class ResponsiveSize {
  static double designWidth = 375.0;
  static double designHeight = 812.0;

  /// 디자인 기준 크기를 한 번에 설정
  static void setDesignSize({required double width, required double height}) {
    designWidth = width;
    designHeight = height;
  }

  final double screenWidth;
  final double screenHeight;

  const ResponsiveSize._({
    required this.screenWidth,
    required this.screenHeight,
  });

  factory ResponsiveSize.of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ResponsiveSize._(
      screenWidth: size.width,
      screenHeight: size.height,
    );
  }

  /// 디자인 기준 너비(375) 대비 비율로 값 계산
  double w(double value) => value * screenWidth / designWidth;

  /// 디자인 기준 높이(812) 대비 비율로 값 계산
  double h(double value) => value * screenHeight / designHeight;

  /// 너비 기반 대칭 수평 패딩
  EdgeInsets px(double value) =>
      EdgeInsets.symmetric(horizontal: w(value));

  /// 높이 기반 대칭 수직 패딩
  EdgeInsets py(double value) =>
      EdgeInsets.symmetric(vertical: h(value));

  /// 너비/높이 기반 대칭 패딩
  EdgeInsets pxy({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: w(horizontal), vertical: h(vertical));

  /// 좌/우는 너비 기반, 상/하는 높이 기반
  EdgeInsets fromLTRB(double left, double top, double right, double bottom) =>
      EdgeInsets.fromLTRB(w(left), h(top), w(right), h(bottom));

  /// 너비 기반
  BorderRadius radius(double value) =>
      BorderRadius.circular(w(value));

  /// 너비 비율 계수
  double get scaleW => screenWidth / designWidth;

  /// 높이 비율 계수
  double get scaleH => screenHeight / designHeight;
}
