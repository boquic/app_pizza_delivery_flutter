import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../injection_container.dart';

class OrderTrackingPage extends ConsumerStatefulWidget {
  final int orderId;

  const OrderTrackingPage({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends ConsumerState<OrderTrackingPage> {
  final MapController _mapController = MapController();
  final WebSocketService _webSocketService = getIt<WebSocketService>();
  
  // Coordenadas iniciales (Pizzería - Ejemplo: Plaza de Armas de Arequipa)
  LatLng _driverLocation = const LatLng(-16.3988, -71.5350); 
  String _currentStatus = 'PREPARANDO';
  bool _isMapReady = false;

  final List<String> _orderSteps = [
    'PENDIENTE',
    'CONFIRMADO',
    'PREPARANDO',
    'EN_CAMINO',
    'ENTREGADO',
  ];

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    if (!_webSocketService.isConnected) {
      _webSocketService.connect(
        onPedidoUpdate: _handleOrderUpdate,
      );
    }
    
    // Suscribirse específicamente a este pedido
    Future.delayed(const Duration(seconds: 1), () {
      _webSocketService.subscribeToPedido(widget.orderId, _handleOrderUpdate);
    });
  }

  void _handleOrderUpdate(Map<String, dynamic> data) {
    if (!mounted) return;

    setState(() {
      if (data.containsKey('estado')) {
        _currentStatus = data['estado'];
      }
      
      if (data.containsKey('lat') && data.containsKey('lng')) {
        final newLocation = LatLng(
          double.parse(data['lat'].toString()),
          double.parse(data['lng'].toString()),
        );
        _driverLocation = newLocation;
        if (_isMapReady) {
          _mapController.move(newLocation, 15);
        }
      }
    });
  }

  @override
  void dispose() {
    _webSocketService.unsubscribeFromPedido(widget.orderId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguimiento Pedido #${widget.orderId}'),
      ),
      body: Column(
        children: [
          // Mapa
          Expanded(
            flex: 2,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _driverLocation,
                initialZoom: 15,
                onMapReady: () => _isMapReady = true,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.pizzasreyna.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _driverLocation,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.delivery_dining,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Timeline de estados
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado del Pedido',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _orderSteps.length,
                      itemBuilder: (context, index) {
                        final step = _orderSteps[index];
                        final isCompleted = _orderSteps.indexOf(_currentStatus) >= index;
                        final isCurrent = step == _currentStatus;

                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          child: Column(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCompleted ? Colors.green : Colors.grey[300],
                                  border: isCurrent
                                      ? Border.all(color: Colors.green, width: 2)
                                      : null,
                                ),
                                child: isCompleted
                                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                                    : null,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                step,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                  color: isCompleted ? Colors.black : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
