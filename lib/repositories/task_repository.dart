import 'package:todo_app/data/sqlflite_service.dart';

class TaskRepository {
  final SqlfliteService dbService;

  TaskRepository(this.dbService);

  void addTask(String title, String description) {
    dbService.add(title, description);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    return await dbService.getAll();
  }

  void deleteTask(int id) {
    dbService.delete(id);
  }

  void updateTask(int id, String title, String description,int isTrue) {
    dbService.update(id, title, description,isTrue);
  }
}
