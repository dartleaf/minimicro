import 'package:file/local.dart' show LocalFileSystem;
import 'package:path_provider/path_provider.dart';

class FileSystem extends LocalFileSystem {
  FileSystem() : super();

  Future<void> init() async {
    final root = await getApplicationDocumentsDirectory();

    currentDirectory = root.path;
  }
}
