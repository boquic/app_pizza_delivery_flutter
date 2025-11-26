/// Constantes de la API

/// Estados de pedidos disponibles
class EstadoPedido {
  static const String pendiente = 'PENDIENTE';
  static const String confirmado = 'CONFIRMADO';
  static const String enPreparacion = 'EN_PREPARACION';
  static const String listo = 'LISTO';
  static const String enCamino = 'EN_CAMINO';
  static const String entregado = 'ENTREGADO';
  static const String cancelado = 'CANCELADO';

  static const List<String> todos = [
    pendiente,
    confirmado,
    enPreparacion,
    listo,
    enCamino,
    entregado,
    cancelado,
  ];

  static String getDisplayName(String estado) {
    switch (estado) {
      case pendiente:
        return 'Pendiente';
      case confirmado:
        return 'Confirmado';
      case enPreparacion:
        return 'En Preparación';
      case listo:
        return 'Listo';
      case enCamino:
        return 'En Camino';
      case entregado:
        return 'Entregado';
      case cancelado:
        return 'Cancelado';
      default:
        return estado;
    }
  }
}

/// Tamaños de pizzas disponibles
class TamanioPizza {
  static const String pequena = 'PEQUEÑA';
  static const String mediana = 'MEDIANA';
  static const String grande = 'GRANDE';
  static const String familiar = 'FAMILIAR';

  static const List<String> todos = [
    pequena,
    mediana,
    grande,
    familiar,
  ];

  static String getDisplayName(String tamanio) {
    switch (tamanio) {
      case pequena:
        return 'Pequeña';
      case mediana:
        return 'Mediana';
      case grande:
        return 'Grande';
      case familiar:
        return 'Familiar';
      default:
        return tamanio;
    }
  }
}

/// Roles de usuario
class UserRole {
  static const String usuario = 'USUARIO';
  static const String admin = 'ADMIN';
  static const String repartidor = 'REPARTIDOR';
}

/// Credenciales admin por defecto
class DefaultCredentials {
  static const String adminEmail = 'admin@pizzasreyna.com';
  static const String adminPassword = 'admin123';
}
