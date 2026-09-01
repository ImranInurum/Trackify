import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

/// Simple enum to describe the file source chosen in the bottom sheet.
enum PickSource { camera, gallery, pdf }

/// Stateless utility that picks a file from camera, gallery, or file system.
/// No repository or use-case involvement.
class PickerService {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<String?> pick(PickSource source) async {
    if (source == PickSource.pdf) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      return result?.files.single.path;
    }

    final imageSource = source == PickSource.camera
        ? ImageSource.camera
        : ImageSource.gallery;

    final picked = await _imagePicker.pickImage(
      source: imageSource,
      imageQuality: 80,
    );
    return picked?.path;
  }
}
