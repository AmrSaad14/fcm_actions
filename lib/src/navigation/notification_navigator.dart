import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../models/configuration_models.dart';
import '../models/notification_message.dart';

/// Named-route navigation without application switch statements.
final class NotificationNavigator {
  NotificationNavigator({
    required GlobalKey<NavigatorState>? navigatorKey,
    Iterable<RouteMapper> routes = const <RouteMapper>[],
  }) : _navigatorKey = navigatorKey {
    registerAll(routes);
  }

  final GlobalKey<NavigatorState>? _navigatorKey;
  final Map<String, RouteMapper> _routes = <String, RouteMapper>{};

  void register(RouteMapper mapper) => _routes[mapper.type] = mapper;

  void registerAll(Iterable<RouteMapper> routes) {
    for (final route in routes) {
      register(route);
    }
  }

  Future<Object?> navigateMessage(NotificationMessage message) async {
    final mapper = message.routeType == null
        ? null
        : _routes[message.routeType];
    final route = mapper?.route ?? message.deepLink;
    if (route == null || route.isEmpty) return null;
    return navigate(
      route,
      arguments: message.data,
      replace: mapper?.replace ?? false,
    );
  }

  Future<Object?> navigate(
    String route, {
    Object? arguments,
    bool replace = false,
  }) async {
    var navigator = _navigatorKey?.currentState;
    if (navigator == null) {
      final ready = Completer<void>();
      SchedulerBinding.instance.addPostFrameCallback((_) => ready.complete());
      await ready.future;
      navigator = _navigatorKey?.currentState;
    }
    if (navigator == null) return null;
    if (replace) {
      return navigator.pushReplacementNamed(route, arguments: arguments);
    }
    return navigator.pushNamed(route, arguments: arguments);
  }
}
