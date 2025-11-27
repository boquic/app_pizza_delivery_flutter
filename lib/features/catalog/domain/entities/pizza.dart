import 'package:freezed_annotation/freezed_annotation.dart';

part 'pizza.freezed.dart';

/// Entidad de Pizza (actualizada para coincidir con backend)
@freezed
class Pizza with _$Pizza {
  const factory Pizza({
    required int id,
    required String nombre,
    required String descripcion,
    required double precioBase,
    required String tamanio,
    required bool disponible,
    String? imagenUrl,
    required bool esPersonalizada,
    @Default([]) List<Ingrediente> ingredientes,
  }) = _Pizza;
}

/// Entidad de Ingrediente
@freezed
class Ingrediente with _$Ingrediente {
  const factory Ingrediente({
    required int id,
    required String nombre,
    required String descripcion,
    required double precioAdicional,
    required bool disponible,
    String? imagenUrl,
  }) = _Ingrediente;
}
