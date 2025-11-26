import 'package:flutter/material.dart';
import 'package:rpg_app/domain/entities/arena.dart';
import 'package:rpg_app/domain/entities/heroi.dart';
import 'package:rpg_app/presenter/personagens/personagens_view.dart';

class ArenaView extends StatefulWidget {
  const ArenaView({super.key});

  @override
  State<ArenaView> createState() => _ArenaViewState();
}

class _ArenaViewState extends State<ArenaView> {
  final List<Arena> _arenas = [];
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _missaoController = TextEditingController();

  Heroi? _personagem1;
  Heroi? _personagem2;

  void _criarArena() {
    if (_nomeController.text.isEmpty || _missaoController.text.isEmpty) {
      _showMessage('Por favor, preencha o nome da arena e a missão');
      return;
    }
    if (_personagem1 == null || _personagem2 == null) {
      _showMessage('Por favor, selecione dois personagens para a batalha');
      return;
    }
    if (_personagem1 == _personagem2) {
      _showMessage('Os personagens devem ser diferentes para uma batalha justa');
      return;
    }

    var novaArena = Arena(nome: _nomeController.text, missao: _missaoController.text);
    novaArena.criarBatalha(_personagem1!, _personagem2!);
    setState(() {
      _arenas.add(novaArena);
      _nomeController.clear();
      _missaoController.clear();
      _personagem1 = null;
      _personagem2 = null;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _selecionarPersonagem1() async {
    final personagem = await Navigator.push<Heroi>(
      context,
      MaterialPageRoute(builder: (context) => const PersonagensView()),
    );
    if (personagem != null) {
      setState(() {
        _personagem1 = personagem;
      });
    }
  }

  void _selecionarPersonagem2() async {
    final personagem = await Navigator.push<Heroi>(
      context,
      MaterialPageRoute(builder: (context) => const PersonagensView()),
    );
    if (personagem != null) {
      setState(() {
        _personagem2 = personagem;
      });
    }
  }

  Widget _buildArenaCard(Arena arena) {
    return Card(
      child: ExpansionTile(
        title: Text(arena.nome),
        subtitle: Text('Missão: ${arena.missao}'),
        children: arena.batalhas.map((batalha) {
          return ListTile(
            title: Text(batalha.resultado()),
            subtitle: Text(
                '${batalha.personagem1.nome} vs ${batalha.personagem2.nome}'),
            trailing: Text(
                '${batalha.data.toLocal().toString().split('.')[0]}'),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arena'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Arena',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _missaoController,
                decoration: const InputDecoration(
                  labelText: 'Missão',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selecionarPersonagem1,
                      child: Text(_personagem1 != null
                          ? _personagem1!.nome
                          : 'Selecione Personagem 1'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selecionarPersonagem2,
                      child: Text(_personagem2 != null
                          ? _personagem2!.nome
                          : 'Selecione Personagem 2'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _criarArena,
                child: const Text('Criar Arena e Batalha'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              ..._arenas.map(_buildArenaCard).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
