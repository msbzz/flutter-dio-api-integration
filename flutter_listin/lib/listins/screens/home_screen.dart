import 'package:flutter/material.dart';
import 'package:flutter_listin/_core/services/dio_service.dart';
import 'package:flutter_listin/authentication/models/mock_user.dart';
import 'package:flutter_listin/listins/data/database.dart';
import 'package:flutter_listin/listins/screens/widgets/home_drawer.dart';
import 'package:flutter_listin/listins/screens/widgets/home_listin_item.dart';
import '../models/listin.dart';
import 'widgets/listin_add_edit_modal.dart';
import 'widgets/listin_options_modal.dart';

class HomeScreen extends StatefulWidget {
  final MockUser user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Listin> listListins = [];
  late AppDatabase _appDatabase;

  DioService _dio = DioService();
  
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _appDatabase = AppDatabase();
    refresh();
    super.initState();
  }

  @override
  void dispose() {
    _appDatabase.close();
    searchController.dispose();
    super.dispose();
  }

  void _sortListins(SortOption option) {
    setState(() {
      if (option == SortOption.name) {
        listListins.sort((a, b) => a.name.compareTo(b.name));
      } else if (option == SortOption.date) {
        listListins.sort((a, b) => a.dateUpdate.compareTo(b.dateUpdate));
      }
    });
  }

  void _searchListins(String query) {
    refresh(query: query);
  }

void _cloudAction(CloudOption option) {
  String confirmationMessage = '';

  switch (option) {
    case CloudOption.save:
      confirmationMessage = 'Você tem certeza que deseja salvar na nuvem?';
      break;
    case CloudOption.sync:
      confirmationMessage = 'Você tem certeza que deseja sincronizar da nuvem?';
      break;
    case CloudOption.remove:
      confirmationMessage = 'Você tem certeza que deseja remover os dados da nuvem?';
      break;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmação'),
        content: Text(confirmationMessage),
        actions: <Widget>[
          TextButton(
            child: const  Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo sem fazer nada
            },
          ),
          TextButton(
            child: const  Text('Confirmar'),
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo e continua
              switch (option) {
                case CloudOption.save:
                  saveOnServer();
                  break;
                case CloudOption.sync:
                  syncWithServer();
                  break;
                case CloudOption.remove:
                  clearServerData();
                  break;
              }
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(user: widget.user),
      appBar: AppBar(
        title: const Text("Minhas listas"),
        actions: <Widget>[
          PopupMenuButton<dynamic>(
            icon: const Icon(Icons.cloud), // Ícone do menu
            onSelected: (value) {
              if (value is SortOption) {
                _sortListins(value);
              } else if (value is CloudOption) {
                _cloudAction(value);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<dynamic>>[
              const PopupMenuItem<CloudOption>(
                value: CloudOption.save,
                child: ListTile(
                  leading: Icon(Icons.upload),
                  title: Text('Salvar na nuvem')),
              ),
              const PopupMenuItem<CloudOption>(
                value: CloudOption.sync,
                child: ListTile(
                  leading: Icon(Icons.download),
                  title:Text('Sincronizar da nuvem')),
              ),
              const PopupMenuItem<CloudOption>(
                value: CloudOption.remove,
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title:Text('Remover dados da nuvem')),
              ),
              const PopupMenuDivider(), // Traço separador
              const PopupMenuItem<SortOption>(
                value: SortOption.name,
                child: ListTile(
                  leading: Icon(Icons.arrow_upward),
                  title:Text('Ordenar por nome')),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.date,
                child: ListTile(
                  leading: Icon(Icons.arrow_downward),
                  title:Text('Ordenar por data de alteração')),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddModal();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (listListins.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar Listins',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _searchListins(searchController.text);
                    },
                  ),
                ),
                onSubmitted: _searchListins,
              ),
            ),
          Expanded(
            child: (listListins.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/bag.png"),
                        const SizedBox(height: 32),
                        const Text(
                          "Nenhuma lista ainda.\nVamos criar a primeira?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return refresh();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                      child: ListView(
                        children: List.generate(
                          listListins.length,
                          (index) {
                            Listin listin = listListins[index];
                            return HomeListinItem(
                              listin: listin,
                              showOptionModal: showOptionModal,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  showAddModal({Listin? listin}) {
    showAddEditListinModal(
      context: context,
      onRefresh: refresh,
      model: listin,
      appDatabase: _appDatabase,
    );
  }

  showOptionModal(Listin listin) {
    showListinOptionsModal(
      context: context,
      listin: listin,
      onRemove: confirmDelete,
    ).then((value) {
      if (value != null && value) {
        showAddModal(listin: listin);
      }
    });
  }

  refresh({String query = ''}) async {
    List<Listin> listaListins = await _appDatabase.getListns(query: query);
    setState(() {
      listListins = listaListins;
    });
  }

  void confirmDelete(Listin model) async {
    await Future.delayed(Duration.zero, () async {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmação de Exclusão"),
            content: Text(
                "Você tem certeza que deseja excluir a lista '${model.name}'?"),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text("Excluir"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
 
      if (shouldDelete == true) {
        remove(model);
      }
    });
  }

  void remove(Listin model) async {
    await _appDatabase.deleteListin(int.parse(model.id));
    refresh();
  }
  
  void saveOnServer() {
    _dio.saveLocalToServer(_appDatabase);
  }
  
  void syncWithServer() async {
     await _dio.getDataFromServer(_appDatabase);
     await refresh(); 
  }
  
  void clearServerData() {}
}

enum SortOption { name, date }
enum CloudOption { save, sync, remove }
