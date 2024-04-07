import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static late Box box;

  static Future<void> init() async {
    if (!Hive.isBoxOpen("portionsBox")) {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      box = await Hive.openBox("portionsBox");
    }
  }

  static Future<int> getPortions() async {
    return box.get('portions', defaultValue: 0);
  }

  static Future<void> incrementPortions() async {
    await box.put('portions', await getPortions() + 1);
  }
}
