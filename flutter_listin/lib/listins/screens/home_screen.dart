import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(user: widget.user),
      appBar: AppBar(
        title: const Text("Minhas listas"),
        actions: <Widget>[
          PopupMenuButton<SortOption>(
            onSelected: _sortListins,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.name,
                child: Text('Ordenar por nome'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.date,
                child: Text('Ordenar por data de alteração'),
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
}

enum SortOption { name, date }
