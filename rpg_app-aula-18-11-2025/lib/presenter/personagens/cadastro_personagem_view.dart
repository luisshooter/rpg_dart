import 'package:flutter/material.dart';
import 'package:rpg_app/domain/entities/anao.dart';
import 'package:rpg_app/domain/entities/arqueiro.dart';
import 'package:rpg_app/domain/entities/arquetipo.dart';
import 'package:rpg_app/domain/entities/elfo.dart';
import 'package:rpg_app/domain/entities/guerreiro.dart';
import 'package:rpg_app/domain/entities/heroi.dart';
import 'package:rpg_app/domain/entities/humano.dart';
import 'package:rpg_app/domain/entities/mago.dart';
import 'package:rpg_app/domain/entities/orc.dart';
import 'package:rpg_app/domain/entities/raca.dart';


class CadastroPersonagemView extends StatefulWidget {
  final Heroi? personagem;
  const CadastroPersonagemView({Key? key, this.personagem}) : super(key: key);

  @override
  State<CadastroPersonagemView> createState() => _CadastroPersonagemViewState();
}

class _CadastroPersonagemViewState extends State<CadastroPersonagemView> {
  static const int _totalPontos = 30;

  String _imgHeroi = 'personagens/dwarf/dwarf_mage.png';
  final List<Raca> _racas = [
    Humano(bonusVida: 10, bonusEscudo: 10, bonusAtaque: 10),
    Orc(bonusVida: 14, bonusEscudo: 6, bonusAtaque: 10),
    Elfo(bonusVida: 6, bonusEscudo: 8, bonusAtaque: 16),
    Anao(bonusVida: 12, bonusEscudo: 6, bonusAtaque: 12),
  ];
  final List<Arquetipo> _arquetipos = [
    Guerreiro(bonusVida: 8, bonusEscudo: 8, bonusAtaque: 14),
    Arqueiro(bonusVida: 5, bonusEscudo: 5, bonusAtaque: 20),
    Mago(bonusVida: 5, bonusEscudo: 10, bonusAtaque: 15),
  ];

  late Raca _racaSelecionada;
  late Arquetipo _arquetipoSelecionado;
  int _pontosDisponiveis = _totalPontos;
  int _pontosVida = 0;
  int _pontosEscudo = 0;
  int _pontosVelocidade = 0;
  String _nome = '';
  String _reino = '';
  String _missao = '';

  @override
  void initState() {
    super.initState();

    if (widget.personagem != null) {
      final p = widget.personagem!;
      _nome = p.nome;
      _reino = p.reino;
      _missao = p.missao;

      // convert efetivo (vida/escudo que já incluem bônus da raça) para pontos base
      _pontosVida = p.vida - p.raca.bonusVida;
      if (_pontosVida < 0) _pontosVida = 0;
      _pontosEscudo = p.escudo - p.raca.bonusEscudo;
      if (_pontosEscudo < 0) _pontosEscudo = 0;
      // velocidade não tem bônus de raça no modelo atual, usa direto
      _pontosVelocidade = p.velocidade;

      // Set selected race and archetype based on personagem, fallback to defaults if not found
      _racaSelecionada = _racas.firstWhere(
          (r) => r.runtimeType == p.raca.runtimeType,
          orElse: () => _racas[0]);
      _arquetipoSelecionado = _arquetipos.firstWhere(
          (a) => a.runtimeType == p.arquetipo.runtimeType,
          orElse: () => _arquetipos[0]);

      _pontosDisponiveis = _totalPontos - (_pontosVida + _pontosEscudo + _pontosVelocidade);

      _trocarImage();
    } else {
      _racaSelecionada = _racas[0];
      _arquetipoSelecionado = _arquetipos[0];
      _trocarImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Heróis'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        shadowColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                  ),
                  controller: TextEditingController(text: _nome),
                  onChanged: (valor) {
                    _nome = valor;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Reino',
                  ),
                  controller: TextEditingController(text: _reino),
                  onChanged: (valor) {
                    _reino = valor;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Missão',
                  ),
                  controller: TextEditingController(text: _missao),
                  onChanged: (valor) {
                    _missao = valor;
                  },
                ),
                SizedBox(height: 10),
                Image.asset(_imgHeroi, height: 300, fit: BoxFit.contain),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DropdownMenu<Raca>(
                        expandedInsets: EdgeInsets.zero,
                        initialSelection: _racaSelecionada,
                        dropdownMenuEntries: _buildMenuItensRaca(),
                        label: Text('Raça'),
                        onSelected: (raca) {
                          if (raca != null) {
                            _racaSelecionada = raca;
                            _trocarImage();
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownMenu<Arquetipo>(
                        expandedInsets: EdgeInsets.zero,
                        initialSelection: _arquetipoSelecionado,
                        dropdownMenuEntries: _buildMenuItensArquetipo(),
                        label: Text('Arquetipo'),
                        onSelected: (arquetipo) {
                          if (arquetipo != null) {
                            _arquetipoSelecionado = arquetipo;
                            _trocarImage();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('Pontos disponíveis: $_pontosDisponiveis'),
                Column(
                  children: [
                    ListTile(
                      leading: IconButton(
                        onPressed: _minusVida,
                        icon: Icon(Icons.exposure_minus_1, color: Colors.deepPurple),
                      ),
                      trailing: IconButton(
                        onPressed: _addVida,
                        icon: Icon(Icons.plus_one, color: Colors.deepPurple),
                      ),
                      title: Text(
                        'Pontos de vida: $_pontosVida',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: _buildBar(_pontosDisponiveis, _pontosVida),
                    ),
                    Divider(),
                    ListTile(
                      leading: IconButton(
                        onPressed: _minusEscudo,
                        icon: Icon(Icons.exposure_minus_1, color: Colors.deepPurple),
                      ),
                      trailing: IconButton(
                        onPressed: _addEscudo,
                        icon: Icon(Icons.plus_one, color: Colors.deepPurple),
                      ),
                      title: Text(
                        'Pontos de escudo: $_pontosEscudo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: _buildBar(_pontosDisponiveis, _pontosEscudo),
                    ),
                    Divider(),
                    ListTile(
                      leading: IconButton(
                        onPressed: _minusVelocidade,
                        icon: Icon(Icons.exposure_minus_1, color: Colors.deepPurple),
                      ),
                      trailing: IconButton(
                        onPressed: _addVelocidade,
                        icon: Icon(Icons.plus_one, color: Colors.deepPurple),
                      ),
                      title: Text(
                        'Pontos de velocidade: $_pontosVelocidade',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: _buildBar(
                        _pontosDisponiveis,
                        _pontosVelocidade,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: _salvarPersonagem,
                  child: Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuEntry<Raca>> _buildMenuItensRaca() {
    return _racas
        .map((raca) => DropdownMenuEntry(value: raca, label: raca.getName()))
        .toList();
  }

  List<DropdownMenuEntry<Arquetipo>> _buildMenuItensArquetipo() {
    return _arquetipos
        .map(
          (arquetipo) =>
              DropdownMenuEntry(value: arquetipo, label: arquetipo.getName()),
        )
        .toList();
  }

  void _trocarImage() {
    setState(() {
      _imgHeroi = _getImage();
    });
  }

  String _getImage() {
    if (_racaSelecionada is Humano) {
      if (_arquetipoSelecionado is Arqueiro) {
        return 'personagens/human/human_archer.png';
      }
      if (_arquetipoSelecionado is Mago) {
        return 'personagens/human/human_mage.png';
      }
      if (_arquetipoSelecionado is Guerreiro) {
        return 'personagens/human/human_warrior.png';
      }
      return 'personagens/human/human_neutral.png';
    }
    if (_racaSelecionada is Orc) {
      return 'personagens/orc/orc_neutral.png';
    }
    if (_racaSelecionada is Elfo) {
      return 'personagens/elf/elf_neutral.png';
    }
    return 'personagens/dwarf/dwarf_neutral.png';
  }

  void _addVida() {
    setState(() {
      if (_pontosDisponiveis > 0) {
        _pontosDisponiveis--;
        _pontosVida++;
      }
    });
  }

  void _minusVida() {
    setState(() {
      if (_pontosVida > 0) {
        _pontosVida--;
        _pontosDisponiveis++;
      }
    });
  }

  void _addEscudo() {
    setState(() {
      if (_pontosDisponiveis > 0) {
        _pontosDisponiveis--;
        _pontosEscudo++;
      }
    });
  }

  void _minusEscudo() {
    setState(() {
      if (_pontosEscudo > 0) {
        _pontosEscudo--;
        _pontosDisponiveis++;
      }
    });
  }

  void _addVelocidade() {
    setState(() {
      if (_pontosDisponiveis > 0) {
        _pontosDisponiveis--;
        _pontosVelocidade++;
      }
    });
  }

  void _minusVelocidade() {
    setState(() {
      if (_pontosVelocidade > 0) {
        _pontosVelocidade--;
        _pontosDisponiveis++;
      }
    });
  }

  Widget _buildBar(int valorTotal, int valorAtual) {
    final total = (valorTotal <= 0) ? _totalPontos : valorTotal;
    final percentual = (total > 0) ? (valorAtual / total).clamp(0.0, 1.0) : 0.0;
    return LinearProgressIndicator(value: percentual);
  }

  void _salvarPersonagem() {
    // Validação: não permite salvar se ultrapassou o total de pontos
    if (_pontosDisponiveis < 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text(
                'Você ultrapassou o limite de pontos ($_totalPontos). Reduza os pontos alocados para continuar.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (_nome.isEmpty ||
        _reino.isEmpty ||
        _missao.isEmpty ||
        (_pontosVida == 0 && _pontosEscudo == 0 && _pontosVelocidade == 0)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text(
                'Por favor, informe todos os parâmetros necessários: nome, reino, missão e atribua pelo menos um ponto.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final heroi = Heroi(
      nome: _nome,
      reino: _reino,
      missao: _missao,
      vida: _pontosVida,
      escudo: _pontosEscudo,
      velocidade: _pontosVelocidade,
      raca: _racaSelecionada,
      arquetipo: _arquetipoSelecionado,
    );

    Navigator.of(context).pop(heroi);
  }
}
