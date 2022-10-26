import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    //*HOW IS ANIMATED PAGE TRANSITION

    if (settings.name == '/') {
      //FIRST PAGE LOADED NOT ANIMATED
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 2000);

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    //*HOW IS ANIMATED PAGE TRANSITION

    if (route.settings.name == '/') {
      //FIRST PAGE LOADED NOT ANIMATED
      return child;
    }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
