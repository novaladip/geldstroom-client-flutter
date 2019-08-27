import 'package:flutter/material.dart';

class LoadingAnimatedSwitcher extends StatelessWidget {
  final Widget onLoadingChild;
  final Widget onFinishChild;
  final bool isLoading;

  LoadingAnimatedSwitcher({
    this.isLoading,
    this.onFinishChild,
    this.onLoadingChild,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      transitionBuilder: (child, Animation<double> animation) =>
          ScaleTransition(
        child: child,
        scale: animation,
      ),
      child: isLoading ? onLoadingChild : onFinishChild,
    );
  }
}
