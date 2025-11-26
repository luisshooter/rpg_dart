import 'package:flutter/material.dart';
import 'package:rpg_app/domain/entities/arena.dart';

class HistoricoView extends StatefulWidget {
  const HistoricoView({super.key});

  @override
  State<HistoricoView> createState() => _HistoricoViewState();
}

class _HistoricoViewState extends State<HistoricoView> {
  final List<Arena> _arenas = []; // This should be populated from a common data source or shared state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Batalhas'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: _arenas.length,
        itemBuilder: (context, index) {
          final arena = _arenas[index];
          return Card(
            child: ExpansionTile(
              title: Text(arena.nome),
              subtitle: Text('Missão: ${arena.missao}'),
              children: arena.batalhas.map((batalha) {
                return ListTile(
                  title: Text(batalha.resultado()),
                  subtitle: Text('${batalha.personagem1.nome} vs ${batalha.personagem2.nome}'),
                  trailing: Text('${batalha.data.toLocal().toString().split('.')[0]}'),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
