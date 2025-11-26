import 'package:flutter/material.dart';
import 'package:rpg_app/domain/entities/personagem.dart';
import 'package:rpg_app/domain/entities/heroi.dart';
import 'package:rpg_app/presenter/personagens/cadastro_personagem_view.dart';

class PersonagensView extends StatefulWidget {
  const PersonagensView({super.key});

  @override
  State<PersonagensView> createState() => _PersonagensViewState();
}

class _PersonagensViewState extends State<PersonagensView> {
  final List<Personagem> _personagens = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personagens'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        shadowColor: Colors.deepPurpleAccent,
      ),
      body: _construirLista(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroPersonagemView()),
          );
          if (!context.mounted) return;

          if (result != null && result is Heroi) {
            setState(() {
              _personagens.add(result);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Personagem Cadastrado com Sucesso'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  ListView _construirLista() {
    return ListView.builder(
      itemCount: _personagens.length,
      itemBuilder: (context, index) {
        final personagem = _personagens[index];
        if (personagem is Heroi) {
          return ListTile(
            title: Text(personagem.nome),
            subtitle: Text('Raça: ${personagem.raca.getName()}, Arquetipo: ${personagem.arquetipo.getName()}, Reino: ${personagem.reino}, Missão: ${personagem.missao}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final personagemEditado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroPersonagemView(
                          personagem: personagem as Heroi,
                        ),
                      ),
                    );

                    if (personagemEditado != null && personagemEditado is Heroi) {
                      setState(() {
                        _personagens[index] = personagemEditado;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: const [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 10),
                              Text('Personagem Atualizado com Sucesso'),
                            ],
                          ),
                          backgroundColor: Colors.blue,
                          duration: Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _personagens.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: const [
                            Icon(Icons.delete, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Usuário Excluído com Sucesso'),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
