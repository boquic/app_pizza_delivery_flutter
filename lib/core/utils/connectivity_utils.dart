import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

// TODO: Descomentar cuando se genere el código
// part 'connectivity_utils.g.dart';

// TODO: Implementar provider cuando se necesite
// @riverpod
// Stream<bool> connectivity(Ref ref) {
//   final connectivity = Connectivity();
//   
//   return connectivity.onConnectivityChanged.map((result) {
//     return result.any((r) => 
//       r == ConnectivityResult.mobile || 
//       r == ConnectivityResult.wifi ||
//       r == ConnectivityResult.ethernet
//     );
//   });
// }

/// Utilidad para verificar conectividad
class ConnectivityUtils {
  static final Connectivity _connectivity = Connectivity();

  /// Verifica si hay conexión a internet
  static Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.any((r) => 
      r == ConnectivityResult.mobile || 
      r == ConnectivityResult.wifi ||
      r == ConnectivityResult.ethernet
    );
  }

  /// Stream de cambios de conectividad
  static Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      return result.any((r) => 
        r == ConnectivityResult.mobile || 
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet
      );
    });
  }
}
