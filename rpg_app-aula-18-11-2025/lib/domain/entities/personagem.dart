import 'package:flutter/foundation.dart';
import 'package:rpg_app/domain/entities/raca.dart';

abstract class Personagem {
  final String _nome;
  // armazenamos os pontos 'base' (sem os bônus da raça)
  int _vidaBase;
  final int _escudoBase;
  final int _velocidadeBase;
  final Raca _raca;

  Personagem({
    required String nome,
    required int vida, // vida base
    required int escudo, // escudo base
    required int velocidade, // velocidade base
    required Raca raca,
  })  : _nome = nome,
        _vidaBase = vida,
        _escudoBase = escudo,
        _velocidadeBase = velocidade,
        _raca = raca;

  String get nome => _nome;

  // getters retornam os valores efetivos (base + bonus da raça)
  int get vida => _vidaBase + _raca.bonusVida;
  int get escudo => _escudoBase + _raca.bonusEscudo;
  int get velocidade => _velocidadeBase;
  Raca get raca => _raca;

  void defender(int dano) {
    final danoReal = dano - escudo;
    if (danoReal > 0) {
      // reduzimos a vida base pelo dano real
      _vidaBase -= danoReal;
    }
    // garante que a vida efetiva nunca fique negativa
    if (vida < 0) {
      // ajusta _vidaBase para que getter `vida` retorne 0
      _vidaBase = -_raca.bonusVida;
    }
  }

  bool estaVivo() {
    return vida > 0;
  }

  void atacar(Personagem oponente, int dano) {
    debugPrint('Nome do atacante $_nome');
    debugPrint('Nome oponente ${oponente._nome}');
    // bônus de ataque da raça já está em _raca.bonusAtaque
    oponente.defender(dano + _raca.bonusAtaque);
  }

  void exibirStatus() {
    debugPrint('Nome: $_nome - Vida: $vida');
  }
}
