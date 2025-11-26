import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../config/env_config.dart';

class WebSocketService {
  StompClient? _stompClient;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void connect({
    required Function(Map<String, dynamic>) onPedidoUpdate,
    Function(int)? onNuevoPedido,
  }) {
    _stompClient = StompClient(
      config: StompConfig(
        url: EnvConfig.wsUrl,
        onConnect: (StompFrame frame) {
          _isConnected = true;
          print('✅ Conectado al WebSocket');
          
          // Suscribirse a nuevos pedidos (para admin)
          if (onNuevoPedido != null) {
            _stompClient?.subscribe(
              destination: '/topic/pedidos/nuevos',
              callback: (frame) {
                if (frame.body != null) {
                  final pedidoId = int.parse(frame.body!);
                  onNuevoPedido(pedidoId);
                }
              },
            );
          }
        },
        onWebSocketError: (dynamic error) {
          _isConnected = false;
          print('❌ WebSocket Error: $error');
        },
        onDisconnect: (frame) {
          _isConnected = false;
          print('🔌 Desconectado del WebSocket');
        },
        onStompError: (frame) {
          print('❌ STOMP Error: ${frame.body}');
        },
      ),
    );

    _stompClient?.activate();
  }

  void subscribeToPedido(int pedidoId, Function(Map<String, dynamic>) onUpdate) {
    if (!_isConnected) {
      print('⚠️ No conectado al WebSocket');
      return;
    }

    _stompClient?.subscribe(
      destination: '/topic/pedidos/$pedidoId',
      callback: (frame) {
        if (frame.body != null) {
          final estado = jsonDecode(frame.body!) as Map<String, dynamic>;
          onUpdate(estado);
        }
      },
    );
  }

  void unsubscribeFromPedido(int pedidoId) {
    _stompClient?.unsubscribe(destination: '/topic/pedidos/$pedidoId');
  }

  void disconnect() {
    _stompClient?.deactivate();
    _isConnected = false;
  }
}
