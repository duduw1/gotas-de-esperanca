import 'package:flutter/material.dart';

class CampanhasScreen extends StatefulWidget {
  const CampanhasScreen({super.key});
  static const String routeName = '/campanhas';

  @override
  State<CampanhasScreen> createState() => _CampanhasScreenState();
}

class _CampanhasScreenState extends State<CampanhasScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _campanhas = [
    'Campanha do Agasalho',
    'Campanha da Solidariedade',
    'Campanha de Alimentos',
    'Campanha de Brinquedos',
  ];
  List<String> _filteredCampanhas = [];

  @override
  void initState() {
    super.initState();
    _filteredCampanhas = List.from(_campanhas);
  }

  void _searchCampanhas(String query) {
    setState(() {
      _filteredCampanhas = _campanhas
          .where((c) => c.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _cadastrarCampanha() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _newCampanhaController = TextEditingController();
        return AlertDialog(
          title: const Text('Cadastrar Nova Campanha'),
          content: TextField(
            controller: _newCampanhaController,
            decoration: const InputDecoration(hintText: 'Nome da campanha'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newCampanhaController.text.trim().isNotEmpty) {
                  setState(() {
                    _campanhas.add(_newCampanhaController.text.trim());
                    _filteredCampanhas = List.from(_campanhas);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Cadastrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campanhas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _cadastrarCampanha,
            tooltip: 'Cadastrar nova campanha',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar campanha',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchCampanhas,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredCampanhas.isEmpty
                  ? const Center(child: Text('Nenhuma campanha encontrada.'))
                  : ListView.builder(
                      itemCount: _filteredCampanhas.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_filteredCampanhas[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
