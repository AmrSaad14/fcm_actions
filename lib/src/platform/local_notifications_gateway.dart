import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/configuration_models.dart';
import '../models/enums.dart';
import '../models/notification_action.dart';
import '../models/notification_message.dart';
import 'background_dispatcher.dart';
import 'platform_gateways.dart';

final class FlutterLocalNotificationsGateway
    implements LocalNotificationsGateway {
  FlutterLocalNotificationsGateway({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final Map<String, DarwinNotificationCategory> _categories =
      <String, DarwinNotificationCategory>{};
  String _icon = '@mipmap/ic_launcher';
  PlatformNotificationResponseCallback? _onResponse;

  @override
  Future<PlatformNotificationResponse?> initialize({
    required String defaultAndroidIcon,
    required bool requestPermission,
    required List<NotificationMessage> categoryTemplates,
    required PlatformNotificationResponseCallback onResponse,
  }) async {
    _icon = defaultAndroidIcon;
    _onResponse = onResponse;
    _addCategories(categoryTemplates);
    await _initializePlugin(requestPermission: requestPermission);

    if (requestPermission) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    final launch = await _plugin.getNotificationAppLaunchDetails();
    final response = launch?.notificationResponse;
    if (launch?.didNotificationLaunchApp != true || response == null) {
      return null;
    }
    return _convert(response, launchedApp: true);
  }

  Future<void> _initializePlugin({required bool requestPermission}) =>
      _plugin.initialize(
        settings: InitializationSettings(
          android: AndroidInitializationSettings(_icon),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: requestPermission,
            requestBadgePermission: requestPermission,
            requestSoundPermission: requestPermission,
            notificationCategories: _categories.values.toList(),
          ),
        ),
        onDidReceiveNotificationResponse: (response) async {
          await _onResponse?.call(_convert(response));
        },
        onDidReceiveBackgroundNotificationResponse:
            fcmActionsBackgroundNotificationResponse,
      );

  @override
  Future<void> createChannels(Iterable<NotificationChannel> channels) async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;
    for (final channel in channels) {
      await android.createNotificationChannel(
        AndroidNotificationChannel(
          channel.id,
          channel.name,
          description: channel.description,
          importance: _importance(channel.importance),
          playSound: channel.playSound,
          sound: channel.sound == null
              ? null
              : RawResourceAndroidNotificationSound(channel.sound),
          enableVibration: channel.enableVibration,
          showBadge: channel.showBadge,
        ),
      );
    }
  }

  @override
  Future<void> registerCategories(
    Iterable<NotificationMessage> templates,
  ) async {
    final before = _categories.length;
    _addCategories(templates);
    if (_categories.length != before) {
      // The plugin registers Darwin categories during initialization.
      await _initializePlugin(requestPermission: false);
    }
  }

  void _addCategories(Iterable<NotificationMessage> templates) {
    for (final template in templates) {
      final id = template.categoryId;
      if (id == null || template.actions.isEmpty) continue;
      _categories[id] = DarwinNotificationCategory(
        id,
        actions: template.actions.map(_darwinAction).toList(),
        options: const <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.customDismissAction,
        },
      );
    }
  }

  @override
  Future<void> show(
    NotificationMessage message,
    NotificationChannel channel,
  ) async {
    await registerCategories(<NotificationMessage>[message]);
    final androidActions = message.actions.map(_androidAction).toList();
    await _plugin.show(
      id: message.notificationId,
      title: message.title,
      body: message.body,
      payload: jsonEncode(message.toJson()),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: _importance(channel.importance),
          priority: _priority(channel.importance),
          playSound: channel.playSound,
          sound: channel.sound == null
              ? null
              : RawResourceAndroidNotificationSound(channel.sound),
          enableVibration: channel.enableVibration,
          channelShowBadge: channel.showBadge,
          silent: channel.importance == ChannelImportance.silent,
          styleInformation: message.body == null
              ? null
              : BigTextStyleInformation(message.body!),
          actions: androidActions,
          dismissIsolate: NotificationDismissedIsolate.main,
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: message.categoryId,
          presentAlert: !message.silent,
          presentBanner: !message.silent,
          presentList: !message.silent,
          presentSound: channel.playSound && !message.silent,
          sound: channel.sound,
          presentBadge: channel.showBadge,
        ),
      ),
    );
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  static AndroidNotificationAction _androidAction(NotificationAction action) =>
      AndroidNotificationAction(
        action.id,
        action.title,
        icon: action.icon == null
            ? null
            : DrawableResourceAndroidBitmap(action.icon!),
        showsUserInterface:
            action.executionMode == ActionExecutionMode.foreground ||
            (action.executionMode == ActionExecutionMode.any &&
                action.showsUserInterface),
        allowGeneratedReplies: action.input,
        inputs: action.input
            ? <AndroidNotificationActionInput>[
                AndroidNotificationActionInput(label: action.inputLabel),
              ]
            : const <AndroidNotificationActionInput>[],
      );

  static DarwinNotificationAction _darwinAction(NotificationAction action) {
    final options = <DarwinNotificationActionOption>{
      if (action.destructive) DarwinNotificationActionOption.destructive,
      // Keeping Darwin actions on the main isolate avoids requiring consumers
      // to modify AppDelegate solely to register background-isolate plugins.
      DarwinNotificationActionOption.foreground,
    };
    if (action.input) {
      return DarwinNotificationAction.text(
        action.id,
        action.title,
        buttonTitle: action.title,
        placeholder: action.inputLabel,
        options: options,
      );
    }
    return DarwinNotificationAction.plain(
      action.id,
      action.title,
      options: options,
    );
  }

  static PlatformNotificationResponse _convert(
    NotificationResponse response, {
    bool launchedApp = false,
  }) => PlatformNotificationResponse(
    notificationId: response.id,
    payload: response.payload,
    actionId: response.actionId,
    input: response.input,
    dismissed:
        response.notificationResponseType ==
        NotificationResponseType.notificationDismissed,
    launchedApp: launchedApp,
    fromBackground: false,
  );

  static Importance _importance(ChannelImportance importance) =>
      switch (importance) {
        ChannelImportance.max => Importance.max,
        ChannelImportance.high => Importance.high,
        ChannelImportance.defaultImportance => Importance.defaultImportance,
        ChannelImportance.low => Importance.low,
        ChannelImportance.silent => Importance.none,
      };

  static Priority _priority(ChannelImportance importance) =>
      switch (importance) {
        ChannelImportance.max => Priority.max,
        ChannelImportance.high => Priority.high,
        ChannelImportance.defaultImportance => Priority.defaultPriority,
        ChannelImportance.low => Priority.low,
        ChannelImportance.silent => Priority.min,
      };
}
