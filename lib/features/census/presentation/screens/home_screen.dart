import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:niu_guardian/features/census/presentation/providers/census_provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar formularios al iniciar
    Future.microtask(() => ref.read(censusProvider.notifier).loadForms());
  }

  @override
  Widget build(BuildContext context) {
    final censusState = ref.watch(censusProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo/niu.png',
          height: 30,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: censusState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : censusState.forms.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay registros aún',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Comienza creando un nuevo censo',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: censusState.forms.length,
                  itemBuilder: (context, index) {
                    final form = censusState.forms[index];
                    return Dismissible(
                      key: Key(form.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirmar"),
                              content: const Text(
                                  "¿Estás seguro de que deseas eliminar este registro?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("CANCELAR"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
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
                          ref
                              .read(censusProvider.notifier)
                              .deleteForm(form.id!);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Registro eliminado')),
                            );
                          }
                        }
                      },
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                theme.colorScheme.primary.withOpacity(0.1),
                            child: Text(
                              form.name.isNotEmpty
                                  ? form.name[0].toUpperCase()
                                  : '?',
                              style:
                                  TextStyle(color: theme.colorScheme.primary),
                            ),
                          ),
                          title: Text(
                            '${form.name} ${form.surname}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.cake,
                                      size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(form.birthdate),
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.child_care,
                                      size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${form.children.length} Hijos',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey),
                          onTap: () {
                            // Navegar a detalle o edición (Futuro)
                            // context.go('/edit/${form.id}');
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/create');
        },
        label: const Text('Nuevo Registro'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
