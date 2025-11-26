import 'package:freezed_annotation/freezed_annotation.dart';

part 'usuario_model.freezed.dart';
part 'usuario_model.g.dart';

@freezed
class UsuarioModel with _$UsuarioModel {
  const factory UsuarioModel({
    required int id,
    required String nombre,
    required String apellido,
    required String email,
    String? telefono,
    String? direccion,
    required String rol,
    required bool activo,
  }) = _UsuarioModel;

  factory UsuarioModel.fromJson(Map<String, dynamic> json) =>
      _$UsuarioModelFromJson(json);
}
