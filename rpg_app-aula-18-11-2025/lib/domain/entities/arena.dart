import 'battle.dart';
import 'heroi.dart';

class Arena {
  final String nome;
  final String missao;
  List<Battle> batalhas = [];

  Arena({required this.nome, required this.missao});

  bool criarBatalha(Heroi p1, Heroi p2) {
    if (p1 == p2) return false;
    var batalha = Battle(personagem1: p1, personagem2: p2);
    batalha.iniciar();
    batalhas.add(batalha);
    return true;
  }
}
