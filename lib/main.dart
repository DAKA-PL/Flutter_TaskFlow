import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'task.dart';

void main() {
  runApp(const TaskFlowApp());
}

const demoTasks = <Task>[
  Task(
    id: 101,
    title: 'Modelar entidad Task en Dart',
    description: 'Definir la clase Task con constructor const, factory fromJson y propiedades inmutables en lib/task.dart.',
    priority: 'Alta',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 102,
    title: 'Configurar rutas con go_router',
    description: 'Implementar la navegación declarativa hacia /task/:id para consultar el detalle de cada pendiente.',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 103,
    title: 'Validar cubo OLAP en SSAS',
    description: 'Revisar las medidas calculadas y dimensiones antes de conectar el modelo a Power BI.',
    priority: 'Media',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 104,
    title: 'Probar zonas DNS en RHEL 10',
    description: 'Verificar la resolución directa e inversa en el servidor Linux virtualizado.',
    priority: 'Media',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 105,
    title: 'Documentar alcance en README.md',
    description: 'Escribir historias de usuario, criterios de aceptación y contrato de endpoints REST.',
    priority: 'Baja',
    isCompleted: true,
    userId: 1,
  ),
];

Task? findTask(int? id) {
  for (final task in demoTasks) {
    if (task.id == id) return task;
  }
  return null;
}

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return TaskDetailScreen(task: findTask(id));
      },
    ),
  ],
);

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routerConfig: appRouter,
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoTasks.length,
        itemBuilder: (context, index) {
          final task = demoTasks[index];
          return Card(
            child: ListTile(
              leading: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
              ),
              title: Text(task.title),
              subtitle: Text('Prioridad: ${task.priority}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/task/${task.id}'),
            ),
          );
        },
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task? task;

  @override
  Widget build(BuildContext context) {
    final selected = task;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: selected == null
            ? const Text('No se encontró esta tarea.')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selected.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(selected.description),
                  const SizedBox(height: 16),
                  Text('Prioridad: ${selected.priority}'),
                  Text(
                    selected.isCompleted
                        ? 'Estado: completada'
                        : 'Estado: pendiente',
                  ),
                  Text('Usuario: ${selected.userId}'),
                ],
              ),
      ),
    );
  }
}
