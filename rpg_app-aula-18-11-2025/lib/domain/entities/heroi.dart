import 'package:rpg_app/domain/entities/arquetipo.dart';
import 'package:rpg_app/domain/entities/personagem.dart';

class Heroi extends Personagem {
  final String _reino;
  final String _missao;
  final Arquetipo _arquetipo;

  Heroi({
    required String reino,
    required String missao,
    required Arquetipo arquetipo,
    required super.nome,
    required super.vida,
    required super.escudo,
    required super.velocidade,
    required super.raca,
  }) : _reino = reino,
       _missao = missao,
       _arquetipo = arquetipo;

  String get reino => _reino;
  String get missao => _missao;
  Arquetipo get arquetipo => _arquetipo;
}
