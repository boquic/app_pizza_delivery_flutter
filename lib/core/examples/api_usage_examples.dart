/// Ejemplos de uso de la API
/// Este archivo contiene ejemplos de cómo usar los datasources creados

import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../storage/auth_storage.dart';
import '../services/websocket_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/models/login_request_model.dart';
import '../../features/auth/data/models/register_request_model.dart';
import '../../features/catalog/data/datasources/pizza_api_datasource.dart';
import '../../features/cart/data/datasources/cart_remote_datasource.dart';
import '../../features/cart/data/models/agregar_item_request_model.dart';
import '../../features/orders/data/datasources/orders_remote_datasource.dart';
import '../../features/orders/data/models/crear_pedido_request_model.dart';
import '../../features/admin/data/datasources/admin_pizzas_datasource.dart';
import '../../features/admin/data/datasources/admin_orders_datasource.dart';
import '../../features/admin/data/models/crear_pizza_request_model.dart';
import '../constants/api_constants.dart';

class ApiUsageExamples {
  late final DioClient dioClient;
  late final AuthStorage authStorage;
  late final AuthRemoteDataSource authDataSource;
  late final PizzaApiDataSource pizzaDataSource;
  late final CartRemoteDataSource cartDataSource;
  late final OrdersRemoteDataSource ordersDataSource;
  late final AdminPizzasDataSource adminPizzasDataSource;
  late final AdminOrdersDataSource adminOrdersDataSource;
  late final WebSocketService wsService;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    authStorage = AuthStorage(prefs);
    dioClient = DioClient(authStorage: authStorage);
    
    authDataSource = AuthRemoteDataSourceImpl(dioClient: dioClient);
    pizzaDataSource = PizzaApiDataSourceImpl(dioClient: dioClient);
    cartDataSource = CartRemoteDataSourceImpl(dioClient: dioClient);
    ordersDataSource = OrdersRemoteDataSourceImpl(dioClient: dioClient);
    adminPizzasDataSource = AdminPizzasDataSourceImpl(dioClient: dioClient);
    adminOrdersDataSource = AdminOrdersDataSourceImpl(dioClient: dioClient);
    wsService = WebSocketService();
  }

  // ============ AUTENTICACIÓN ============

  /// Ejemplo: Login de usuario
  Future<void> ejemploLogin() async {
    try {
      final response = await authDataSource.login(
        const LoginRequestModel(
          email: 'admin@pizzasreyna.com',
          password: 'admin123',
        ),
      );

      // Guardar token y datos de usuario
      await authStorage.saveToken(response.token, response.refreshToken);
      await authStorage.saveUserId(response.usuario.id);
      await authStorage.saveUserRol(response.usuario.rol);

      print('✅ Login exitoso: ${response.usuario.nombre}');
      print('🔑 Token: ${response.token}');
      print('👤 Rol: ${response.usuario.rol}');
    } catch (e) {
      print('❌ Error en login: $e');
    }
  }

  /// Ejemplo: Registro de nuevo usuario
  Future<void> ejemploRegistro() async {
    try {
      final response = await authDataSource.register(
        const RegisterRequestModel(
          nombre: 'Juan',
          apellido: 'Pérez',
          email: 'juan@example.com',
          password: 'password123',
          telefono: '987654321',
          direccion: 'Av. Principal 123',
        ),
      );

      await authStorage.saveToken(response.token, response.refreshToken);
      await authStorage.saveUserId(response.usuario.id);
      await authStorage.saveUserRol(response.usuario.rol);

      print('✅ Registro exitoso: ${response.usuario.nombre}');
    } catch (e) {
      print('❌ Error en registro: $e');
    }
  }

  /// Ejemplo: Logout
  Future<void> ejemploLogout() async {
    await authStorage.clearAll();
    dioClient.clearAuthToken();
    print('✅ Sesión cerrada');
  }

  // ============ CATÁLOGO ============

  /// Ejemplo: Obtener lista de pizzas
  Future<void> ejemploObtenerPizzas() async {
    try {
      final pizzas = await pizzaDataSource.getPizzas();
      print('✅ Pizzas obtenidas: ${pizzas.length}');
      
      for (final pizza in pizzas) {
        print('🍕 ${pizza.nombre} - \$${pizza.precioBase} (${pizza.tamanio})');
        print('   Ingredientes: ${pizza.ingredientes.length}');
      }
    } catch (e) {
      print('❌ Error al obtener pizzas: $e');
    }
  }

  /// Ejemplo: Obtener detalle de una pizza
  Future<void> ejemploObtenerPizzaDetalle(int pizzaId) async {
    try {
      final pizza = await pizzaDataSource.getPizzaById(pizzaId);
      print('✅ Pizza: ${pizza.nombre}');
      print('📝 ${pizza.descripcion}');
      print('💰 Precio: \$${pizza.precioBase}');
      print('📏 Tamaño: ${pizza.tamanio}');
      print('✓ Disponible: ${pizza.disponible}');
      
      if (pizza.ingredientes.isNotEmpty) {
        print('🧀 Ingredientes:');
        for (final ing in pizza.ingredientes) {
          print('   - ${ing.nombre} (+\$${ing.precioAdicional})');
        }
      }
    } catch (e) {
      print('❌ Error al obtener pizza: $e');
    }
  }

  // ============ CARRITO ============

  /// Ejemplo: Obtener carrito actual
  Future<void> ejemploObtenerCarrito() async {
    try {
      final carrito = await cartDataSource.getCarrito();
      print('✅ Carrito obtenido');
      print('🛒 Items: ${carrito.items.length}');
      print('💰 Total: \$${carrito.total}');
      
      for (final item in carrito.items) {
        print('   - ${item.pizzaNombre ?? item.comboNombre} x${item.cantidad}');
        print('     Subtotal: \$${item.subtotal}');
        if (item.notas != null) {
          print('     Notas: ${item.notas}');
        }
      }
    } catch (e) {
      print('❌ Error al obtener carrito: $e');
    }
  }

  /// Ejemplo: Agregar pizza al carrito
  Future<void> ejemploAgregarPizzaAlCarrito() async {
    try {
      final carrito = await cartDataSource.agregarItem(
        const AgregarItemRequestModel(
          pizzaId: 1,
          cantidad: 2,
          notas: 'Sin cebolla, extra queso',
          ingredientesPersonalizadosIds: [10, 12], // IDs de ingredientes extra
        ),
      );
      
      print('✅ Pizza agregada al carrito');
      print('💰 Nuevo total: \$${carrito.total}');
    } catch (e) {
      print('❌ Error al agregar al carrito: $e');
    }
  }

  /// Ejemplo: Agregar combo al carrito
  Future<void> ejemploAgregarComboAlCarrito() async {
    try {
      final carrito = await cartDataSource.agregarItem(
        const AgregarItemRequestModel(
          comboId: 1,
          cantidad: 1,
          notas: 'Para llevar',
        ),
      );
      
      print('✅ Combo agregado al carrito');
      print('💰 Nuevo total: \$${carrito.total}');
    } catch (e) {
      print('❌ Error al agregar combo: $e');
    }
  }

  /// Ejemplo: Limpiar carrito
  Future<void> ejemploLimpiarCarrito() async {
    try {
      await cartDataSource.limpiarCarrito();
      print('✅ Carrito limpiado');
    } catch (e) {
      print('❌ Error al limpiar carrito: $e');
    }
  }

  // ============ PEDIDOS ============

  /// Ejemplo: Crear pedido desde items
  Future<void> ejemploCrearPedido() async {
    try {
      final pedido = await ordersDataSource.crearPedido(
        const CrearPedidoRequestModel(
          direccionEntrega: 'Av. Principal 123, Dpto 401',
          telefonoContacto: '987654321',
          notas: 'Tocar el timbre 2 veces',
          items: [
            CrearPedidoItemModel(
              pizzaId: 1,
              cantidad: 2,
              notas: 'Sin cebolla',
              ingredientesPersonalizadosIds: [10, 12],
            ),
            CrearPedidoItemModel(
              comboId: 1,
              cantidad: 1,
            ),
          ],
        ),
      );
      
      print('✅ Pedido creado #${pedido.id}');
      print('📍 Dirección: ${pedido.direccionEntrega}');
      print('💰 Total: \$${pedido.total}');
      print('📅 Fecha: ${pedido.fechaPedido}');
      print('🚚 Entrega estimada: ${pedido.fechaEntregaEstimada}');
      print('📊 Estado: ${pedido.estadoNombre}');
    } catch (e) {
      print('❌ Error al crear pedido: $e');
    }
  }

  /// Ejemplo: Obtener historial de pedidos
  Future<void> ejemploObtenerHistorial() async {
    try {
      final pedidos = await ordersDataSource.getHistorialPedidos();
      print('✅ Historial obtenido: ${pedidos.length} pedidos');
      
      for (final pedido in pedidos) {
        print('📦 Pedido #${pedido.id}');
        print('   Estado: ${pedido.estadoNombre}');
        print('   Total: \$${pedido.total}');
        print('   Fecha: ${pedido.fechaPedido}');
      }
    } catch (e) {
      print('❌ Error al obtener historial: $e');
    }
  }

  /// Ejemplo: Obtener detalle de pedido
  Future<void> ejemploObtenerDetallePedido(int pedidoId) async {
    try {
      final pedido = await ordersDataSource.getPedidoById(pedidoId);
      print('✅ Pedido #${pedido.id}');
      print('👤 Cliente: ${pedido.usuarioNombre}');
      print('📊 Estado: ${pedido.estadoNombre}');
      print('📍 Dirección: ${pedido.direccionEntrega}');
      print('📞 Teléfono: ${pedido.telefonoContacto}');
      print('💰 Subtotal: \$${pedido.subtotal}');
      print('🚚 Envío: \$${pedido.costoEnvio}');
      print('💵 Total: \$${pedido.total}');
      
      if (pedido.repartidorNombre != null) {
        print('🚴 Repartidor: ${pedido.repartidorNombre}');
      }
      
      print('📦 Detalles:');
      for (final detalle in pedido.detalles) {
        print('   - ${detalle.pizzaNombre ?? detalle.comboNombre}');
        print('     Cantidad: ${detalle.cantidad}');
        print('     Precio: \$${detalle.precioUnitario}');
        print('     Subtotal: \$${detalle.subtotal}');
      }
    } catch (e) {
      print('❌ Error al obtener detalle: $e');
    }
  }

  // ============ ADMIN - PIZZAS ============

  /// Ejemplo: Crear nueva pizza (Admin)
  Future<void> ejemploCrearPizza() async {
    try {
      final pizza = await adminPizzasDataSource.crearPizza(
        const CrearPizzaRequestModel(
          nombre: 'Pizza BBQ Especial',
          descripcion: 'Pizza con salsa BBQ, pollo y tocino',
          precioBase: 35.0,
          tamanio: TamanioPizza.grande,
          disponible: true,
          imagenUrl: 'https://example.com/bbq.jpg',
          esPersonalizada: false,
          ingredientes: [],
        ),
      );
      
      print('✅ Pizza creada: ${pizza.nombre}');
      print('🆔 ID: ${pizza.id}');
    } catch (e) {
      print('❌ Error al crear pizza: $e');
    }
  }

  /// Ejemplo: Actualizar pizza (Admin)
  Future<void> ejemploActualizarPizza(int pizzaId) async {
    try {
      final pizza = await adminPizzasDataSource.actualizarPizza(
        pizzaId,
        const CrearPizzaRequestModel(
          nombre: 'Pizza BBQ Especial - Actualizada',
          descripcion: 'Nueva descripción',
          precioBase: 38.0,
          tamanio: TamanioPizza.grande,
          disponible: true,
          esPersonalizada: false,
        ),
      );
      
      print('✅ Pizza actualizada: ${pizza.nombre}');
    } catch (e) {
      print('❌ Error al actualizar pizza: $e');
    }
  }

  /// Ejemplo: Eliminar pizza (Admin)
  Future<void> ejemploEliminarPizza(int pizzaId) async {
    try {
      await adminPizzasDataSource.eliminarPizza(pizzaId);
      print('✅ Pizza eliminada');
    } catch (e) {
      print('❌ Error al eliminar pizza: $e');
    }
  }

  // ============ ADMIN - PEDIDOS ============

  /// Ejemplo: Obtener todos los pedidos (Admin)
  Future<void> ejemploObtenerTodosPedidos() async {
    try {
      final pedidos = await adminOrdersDataSource.getAllPedidos();
      print('✅ Total de pedidos: ${pedidos.length}');
      
      for (final pedido in pedidos) {
        print('📦 #${pedido.id} - ${pedido.usuarioNombre}');
        print('   Estado: ${pedido.estadoNombre}');
        print('   Total: \$${pedido.total}');
      }
    } catch (e) {
      print('❌ Error al obtener pedidos: $e');
    }
  }

  /// Ejemplo: Actualizar estado de pedido (Admin)
  Future<void> ejemploActualizarEstadoPedido(int pedidoId) async {
    try {
      final pedido = await adminOrdersDataSource.actualizarEstado(
        pedidoId,
        EstadoPedido.enCamino,
      );
      
      print('✅ Estado actualizado a: ${pedido.estadoNombre}');
    } catch (e) {
      print('❌ Error al actualizar estado: $e');
    }
  }

  /// Ejemplo: Asignar repartidor (Admin)
  Future<void> ejemploAsignarRepartidor(int pedidoId, int repartidorId) async {
    try {
      final pedido = await adminOrdersDataSource.asignarRepartidor(
        pedidoId,
        repartidorId,
      );
      
      print('✅ Repartidor asignado: ${pedido.repartidorNombre}');
    } catch (e) {
      print('❌ Error al asignar repartidor: $e');
    }
  }

  // ============ WEBSOCKET ============

  /// Ejemplo: Conectar y escuchar actualizaciones
  void ejemploWebSocket() {
    wsService.connect(
      onPedidoUpdate: (estado) {
        print('🔔 Actualización de pedido:');
        print('   ID: ${estado['pedidoId']}');
        print('   Estado: ${estado['estadoNombre']}');
        print('   Fecha: ${estado['fechaCambio']}');
      },
      onNuevoPedido: (pedidoId) {
        print('🆕 Nuevo pedido recibido: #$pedidoId');
      },
    );
  }

  /// Ejemplo: Suscribirse a un pedido específico
  void ejemploSuscribirPedido(int pedidoId) {
    wsService.subscribeToPedido(pedidoId, (estado) {
      print('📍 Pedido #$pedidoId actualizado:');
      print('   Estado: ${estado['estadoNombre']}');
      print('   Descripción: ${estado['estadoDescripcion']}');
    });
  }

  /// Ejemplo: Desconectar WebSocket
  void ejemploDesconectarWebSocket() {
    wsService.disconnect();
    print('✅ WebSocket desconectado');
  }
}
