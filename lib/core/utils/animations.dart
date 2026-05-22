import 'package:flutter/material.dart';

class AppAnimations {
  AppAnimations._();

  static Widget fadeIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
  }) {
    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
          duration: duration,
          child: child,
        );
      },
    );
  }

  static Widget slideUp({
    required Widget child,
    Duration duration = const Duration(milliseconds: 600),
    Duration delay = Duration.zero,
  }) {
    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        return AnimatedSlide(
          offset: snapshot.connectionState == ConnectionState.done
              ? Offset.zero
              : const Offset(0, 0.2),
          duration: duration,
          curve: Curves.easeOutCubic,
          child: child,
        );
      },
    );
  }

  static Widget scaleIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: AnimatedOpacity(
            opacity: value.clamp(0.0, 1.0),
            duration: duration,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
