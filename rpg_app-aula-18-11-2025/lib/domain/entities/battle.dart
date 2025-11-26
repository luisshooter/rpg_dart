import 'heroi.dart';

class Battle {
  final Heroi personagem1;
  final Heroi personagem2;
  late Heroi? vencedor;
  late Heroi? perdedor;
  final DateTime data;

  Battle({
    required this.personagem1,
    required this.personagem2,
  }) : data = DateTime.now();

  void iniciar() {
    // Simplicidade: comparação de pontos de vida + escudo + velocidade para decidir vencedor.
    final poder1 = personagem1.vida + personagem1.escudo + personagem1.velocidade;
    final poder2 = personagem2.vida + personagem2.escudo + personagem2.velocidade;

    if (poder1 > poder2) {
      vencedor = personagem1;
      perdedor = personagem2;
    } else if (poder2 > poder1) {
      vencedor = personagem2;
      perdedor = personagem1;
    } else {
      // Empate fica null
      vencedor = null;
      perdedor = null;
    }
  }

  String resultado() {
    if (vencedor == null) return 'Empate';
    return 'Vencedor: ${vencedor!.nome}';
  }
}
