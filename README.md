# taskflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Alcance de TaskFlow

Problema: necesito organizar actividades académicas y saber cuáles faltan.
Usuario objetivo: estudiante que planifica entregas semanales.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
Lista: tarjetas de tareas y acción para crear.
Detalle: información completa y futuras acciones de editar o eliminar.
Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales
La navegación debe tener textos comprensibles.
Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos
GET /tasks        listar tareas
GET /tasks/:id    consultar detalle
POST /tasks       crear tarea
PATCH /tasks/:id  actualizar tarea
DELETE /tasks/:id eliminar tarea

La API concreta se elegirá después. Estas rutas son requisitos, no
direcciones de un servidor ya conectado.

## API de tareas

TaskFlow consume tareas reales desde una API REST de práctica mediante el paquete **Dio**, siguiendo la cadena de arquitectura `TaskApiService` → `RemoteTaskRepository` → `TasksViewModel`.

* **URL exacta del endpoint:** `https://jsonplaceholder.typicode.com/todos`
* **Parámetro de consulta aplicado:** `userId = 3` (`GET /todos?userId=3`), utilizado para filtrar únicamente las tareas pertenecientes al usuario seleccionado.
* **Campos recibidos desde el servidor (JSON):**
  * `id` (`int`): Identificador único de la tarea.
  * `title` (`String`): Título de la tarea.
  * `completed` (`bool`): Estado remoto, mapeado a la propiedad `isCompleted` del modelo `Task`.
  * `userId` (`int`): Identificador del usuario propietario.
* **Valores completados por defecto en TaskFlow (`Task.fromJson`):**
  * `description`: `'Sin descripción (API)'` (la API pública no incluye descripción).
  * `priority`: `'Sin prioridad (API)'` (la API pública no incluye nivel de prioridad).
* **Comportamiento del cambio de estado (Persistencia):**
  * Marcar una tarea como completada o pendiente desde la pantalla de detalle actualiza únicamente la copia en memoria almacenada en `RemoteTaskRepository` y notifica a las vistas mediante `Provider`. Al reiniciar la aplicación, los datos vuelven a descargarse desde el servidor con su estado original.

  ## Estados de interfaz en la consulta remota

TaskFlow distingue cuatro estados explícitos durante la carga de tareas desde la API mediante `TasksViewModel` (`ChangeNotifier`) y los renderiza de forma reactiva en `TaskListScreen` (`context.watch` y `context.read`):

* **Carga (`isLoading == true`):** Se muestra un `CircularProgressIndicator` acompañado del texto *"Cargando tareas desde el servidor..."* y se deshabilita el botón de recarga superior para evitar peticiones simultáneas. Se comprobó limitando la velocidad de red a *Slow 3G* en Chrome DevTools.
* **Éxito (`tasks.isNotEmpty`):** Renderiza las 20 tareas del usuario `3` dentro de un `RefreshIndicator` + `ListView.builder`, permitiendo actualizar deslizando hacia abajo o pulsando el ícono superior.
* **Vacío (`isEmpty == true`):** Se provocó cambiando temporalmente la constante `userId` a `9999` en `TaskApiService`. El servidor responde con HTTP 200 y lista vacía (`[]`), mostrando el ícono de bandeja vacía, el mensaje *"No hay tareas asignadas a este usuario."* y el botón **Actualizar**.
* **Error (`errorMessage != null`):** Se provocó activando el modo *Offline* en la pestaña *Network* de Chrome DevTools y pulsando el botón de actualizar. La pantalla muestra el ícono de desconexión, el mensaje *"No se pudieron cargar las tareas."* y el botón **Reintentar**, el cual vuelve a ejecutar `loadTasks()` y recupera la lista completa sin necesidad de reiniciar la app tras reactivar la red.