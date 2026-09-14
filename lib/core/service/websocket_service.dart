import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../provider/auth_provider.dart';

class WebSocketService {

  WebSocketService._();
  static final WebSocketService instance = WebSocketService._();

  StompClient? _client;

  bool _connected = false;
  bool get isConnected => _connected;

  final List<Function(String type, dynamic data)> _listeners = [];

  void addMessageListener(Function(String type, dynamic data) listener) {
    _listeners.add(listener);
  }

  void removeMessageListener(Function(String type, dynamic data) listener) {
    _listeners.remove(listener);
  }

  void connect(AuthProvider authProvider) {

    if (_connected) {
      print(
        '========== WebSocket 已经连接，不重复连接 ==========',
      );
      return;
    }

    final user = authProvider.user;

    if (user == null) {
      print(
        '========== 用户未登录，不连接 WebSocket ==========',
      );
      return;
    }

    final token = user.token;

    if (token == null || token.isEmpty) {
      print(
        '========== JWT 不存在，不连接 WebSocket ==========',
      );
      return;
    }

    print(
      '========== 开始连接 WebSocket ==========',
    );

    _client = StompClient(
      config: StompConfig(

        // Spring Boot WebSocket Endpoint
        url: 'ws://192.168.205.55:8080/ws',

        // STOMP CONNECT 请求头
        stompConnectHeaders: {
          'Authorization': 'Bearer $token',
        },

        // =========================
        // STOMP 连接成功
        // =========================

        onConnect: (StompFrame frame) {

          _connected = true;

          print(
            '========== WebSocket 连接成功 ==========',
          );

          _subscribeUserMessages();
        },


        // =========================
        // WebSocket 底层错误
        // =========================

        onWebSocketError: (dynamic error) {

          _connected = false;

          print(
            '========== WebSocket 错误 ==========',
          );

          print(error);
        },


        // =========================
        // WebSocket 断开
        // =========================

        onDisconnect: (StompFrame frame) {

          _connected = false;

          print(
            '========== WebSocket 连接断开 ==========',
          );
        },


        // =========================
        // STOMP 错误
        // =========================

        onStompError: (StompFrame frame) {

          print(
            '========== STOMP 错误 ==========',
          );

          print(
            'headers = ${frame.headers}',
          );

          print(
            'body = ${frame.body}',
          );
        },
      ),
    );

    // 开始连接
    _client!.activate();
  }

  void disconnect() {

    if (_client == null) {
      return;
    }

    print(
      '========== 正在断开 WebSocket ==========',
    );

    _client!.deactivate();

    _client = null;

    _connected = false;

    print(
      '========== WebSocket 已断开 ==========',
    );
  }

  void _subscribeUserMessages() {

    if (_client == null) {
      return;
    }

    _client!.subscribe( // 订阅用户消息
      destination: '/user/queue/messages',
      callback: (StompFrame frame) {
        print(
          '========== 收到 WebSocket 消息 ==========',
        );
        print(
          'headers = ${frame.headers}',
        );
        print(
          'body = ${frame.body}',
        );

        if (frame.body == null || frame.body!.isEmpty) {
          return;
        }

        final body = jsonDecode(frame.body!);
        final type = body['type'];
        final data = body['data'];
        print('WebSocket type = $type');
        print('WebSocket data = $data');

        for (final listener in _listeners) {
          listener(type, data);
        }
      },
    );

    print(
      '========== 已订阅 /user/queue/messages ==========',
    );
  }
}