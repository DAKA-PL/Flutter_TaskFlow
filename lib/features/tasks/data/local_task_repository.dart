import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 101,
      title: 'Modelar entidad Task en Dart',
      description: 'Definir la clase Task con constructor const, factory fromJson y propiedades inmutables en lib/task.dart.',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 102,
      title: 'Configurar rutas con go_router',
      description: 'Implementar la navegación declarativa hacia /task/:id para consultar el detalle de cada pendiente.',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 103,
      title: 'Validar cubo OLAP en SSAS',
      description: 'Revisar las medidas calculadas y dimensiones antes de conectar el modelo a Power BI.',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 104,
      title: 'Probar zonas DNS en RHEL 10',
      description: 'Verificar la resolución directa e inversa en el servidor Linux virtualizado.',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 105,
      title: 'Documentar alcance en README.md',
      description: 'Escribir historias de usuario, criterios de aceptación y contrato de endpoints REST.',
      priority: 'Baja',
      isCompleted: true,
      userId: 1,
    ),
  ];

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_tasks);

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }

  @override
  Future<Task> createTask(
    String title,
    String description,
    String priority,
  ) async {
    final nextId = _tasks.isEmpty
        ? 1
        : _tasks.map((task) => task.id).reduce((a, b) => a > b ? a : b) + 1;
    final task = Task(
      id: nextId,
      title: title,
      description: description,
      priority: priority,
      isCompleted: false,
      userId: 1,
    );
    _tasks.add(task);
    return task;
  }

  @override
  Future<void> updateTask(Task task) async => save(task);

  @override
  Future<void> deleteTask(int id) async {
    _tasks.removeWhere((task) => task.id == id);
  }
}
