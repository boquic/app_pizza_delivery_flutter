/// Constantes de strings de la aplicación
class AppStrings {
  AppStrings._();

  // General
  static const String appName = 'Pizzas Reyna';
  static const String loading = 'Cargando...';
  static const String retry = 'Reintentar';
  static const String cancel = 'Cancelar';
  static const String accept = 'Aceptar';
  static const String save = 'Guardar';
  static const String delete = 'Eliminar';
  static const String edit = 'Editar';
  static const String search = 'Buscar';
  static const String filter = 'Filtrar';
  static const String close = 'Cerrar';

  // Errores
  static const String errorGeneric = 'Ha ocurrido un error';
  static const String errorNoInternet = 'No hay conexión a internet';
  static const String errorTimeout = 'Tiempo de espera agotado';
  static const String errorUnauthorized = 'No autorizado';
  static const String errorNotFound = 'No encontrado';
  static const String errorServer = 'Error del servidor';

  // Catálogo
  static const String catalogTitle = 'Catálogo';
  static const String allCategories = 'Todas';
  static const String noPizzasFound = 'No se encontraron pizzas';
  static const String pizzaNotAvailable = 'No disponible';
  static const String reviews = 'reseñas';

  // Carrito
  static const String cart = 'Carrito';
  static const String emptyCart = 'Tu carrito está vacío';
  static const String addToCart = 'Agregar al carrito';
  static const String removeFromCart = 'Eliminar del carrito';
  static const String checkout = 'Proceder al pago';
  static const String subtotal = 'Subtotal';
  static const String delivery = 'Envío';
  static const String tip = 'Propina';
  static const String total = 'Total';

  // Constructor de pizza
  static const String customizePizza = 'Personalizar pizza';
  static const String selectSize = 'Selecciona el tamaño';
  static const String selectDough = 'Selecciona la masa';
  static const String selectIngredients = 'Selecciona los ingredientes';
  static const String selectCombos = 'Selecciona combos';
  static const String maxIngredientsReached = 'Máximo 8 ingredientes';
  static const String next = 'Siguiente';
  static const String previous = 'Anterior';
  static const String finish = 'Finalizar';

  // Seguimiento
  static const String trackOrder = 'Seguir pedido';
  static const String orderStatus = 'Estado del pedido';
  static const String pending = 'Pendiente';
  static const String preparing = 'Preparando';
  static const String onTheWay = 'En camino';
  static const String delivered = 'Entregado';

  // Perfil
  static const String profile = 'Perfil';
  static const String orderHistory = 'Historial de pedidos';
  static const String addresses = 'Direcciones';
  static const String favorites = 'Favoritos';
  static const String support = 'Soporte';
  static const String logout = 'Cerrar sesión';
  static const String repeatOrder = 'Repetir pedido';

  // Validaciones
  static const String fieldRequired = 'Este campo es requerido';
  static const String invalidEmail = 'Email inválido';
  static const String invalidPhone = 'Teléfono inválido';
  static const String passwordTooShort = 'La contraseña debe tener al menos 6 caracteres';
}
