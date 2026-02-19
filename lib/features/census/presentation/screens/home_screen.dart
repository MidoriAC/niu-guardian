import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:niu_guardian/features/census/domain/entities/child_entity.dart';
import 'package:niu_guardian/features/census/domain/entities/parent_entity.dart';
import 'package:niu_guardian/features/census/presentation/providers/census_provider.dart';
import 'package:niu_guardian/core/utils/snackbar_utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(censusProvider.notifier).loadForms());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final censusState = ref.watch(censusProvider);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: _currentIndex == 0
              ? const Text('Responsables')
              : const Text('Directorio de Hijos'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: _currentIndex == 0
                      ? 'Buscar por nombre o DPI...'
                      : 'Buscar por nombre o COD...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),
        ),
        body: censusState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _currentIndex == 0
                ? _buildParentsList(censusState.forms, theme)
                : _buildChildrenList(censusState.forms, theme),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.push('/census/new');
          },
          label: const Text('Nuevo Registro'),
          icon: const Icon(Icons.add),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
              _searchController.clear();
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Responsables',
            ),
            NavigationDestination(
              icon: Icon(Icons.child_care_outlined),
              selectedIcon: Icon(Icons.child_care),
              label: 'Hijos',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentsList(List<ParentEntity> forms, ThemeData theme) {
    final filteredForms = forms.where((f) {
      final q = _searchQuery.toLowerCase();
      return f.name.toLowerCase().contains(q) ||
          f.surname.toLowerCase().contains(q) ||
          f.documentId.toLowerCase().contains(q);
    }).toList();

    if (filteredForms.isEmpty) {
      return const Center(child: Text("No se encontraron responsables"));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 80),
      itemCount: filteredForms.length,
      itemBuilder: (context, index) {
        final form = filteredForms[index];
        return Dismissible(
          key: Key(form.id.toString()),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Eliminar Responsable"),
                  content: const Text(
                      "Esta acción eliminará al responsable y todos sus hijos asociados.\n\n¿Estás seguro de continuar?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("CANCELAR"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("ELIMINAR",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            if (form.id != null) {
              ref.read(censusProvider.notifier).deleteForm(form.id!);
              CustomSnackBar.showSuccess(
                  context, 'Registro eliminado correctamente');
            }
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  form.name.isNotEmpty ? form.name[0].toUpperCase() : '?',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
              title: Text('${form.name} ${form.surname}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DPI: ${form.documentId}'),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.child_care, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('${form.children.length} Hijos',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
              onTap: () => context.push('/census/${form.id}'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChildrenList(List<ParentEntity> forms, ThemeData theme) {
    final allChildren = <Map<String, dynamic>>[];
    for (var f in forms) {
      for (var c in f.children) {
        allChildren.add({'child': c, 'parent': f});
      }
    }

    final filteredChildren = allChildren.where((item) {
      final child = item['child'] as ChildEntity;
      final q = _searchQuery.toLowerCase();
      return child.name.toLowerCase().contains(q) ||
          child.surname.toLowerCase().contains(q) ||
          child.uniqueCode.toLowerCase().contains(q);
    }).toList();

    if (filteredChildren.isEmpty) {
      return const Center(child: Text("No se encontraron hijos"));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 80),
      itemCount: filteredChildren.length,
      itemBuilder: (context, index) {
        final item = filteredChildren[index];
        final child = item['child'] as ChildEntity;
        final parent = item['parent'] as ParentEntity;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange.withOpacity(0.1),
              child: const Icon(Icons.face, color: Colors.orange),
            ),
            title: Text('${child.name} ${child.surname}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    child.uniqueCode,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 4),
                Text('Encargado: ${parent.name} ${parent.surname}',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.push('/census/${parent.id}'),
          ),
        );
      },
    );
  }
}
