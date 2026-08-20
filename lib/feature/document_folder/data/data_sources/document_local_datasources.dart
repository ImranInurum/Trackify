import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../domain/entities/doucment_entity.dart';
import '../../domain/repository/document_repository.dart';

class DocumentLocalDataSource {
  final ImagePicker picker;

  List<DocumentEntity> storage = [];

  DocumentLocalDataSource(this.picker);

  Future<String?> pickFile(PickerType type) async {
    if (type == PickerType.pdf) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      return result?.files.single.path;
    }

    final source = type == PickerType.camera
        ? ImageSource.camera
        : ImageSource.gallery;

    final picked = await picker.pickImage(source: source);
    if (picked == null) return null;

    /// Crop
    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Crop Document",
          toolbarColor: const Color(0xFF000000),
          toolbarWidgetColor: const Color(0xFFFFFFFF),
        ),
      ],
    );

    if (cropped == null) return null;

    /// Compress
    final compressed = await _compress(File(cropped.path));

    return compressed.path;
  }

  Future _compress(File file) async {
    final target = file.path.replaceAll(".jpg", "_compressed.jpg");

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      target,
      quality: 70,
    );

    return result ?? file;
  }

  Future<void> save(DocumentEntity doc) async {
    storage.add(doc);
  }

  Future<List<DocumentEntity>> getAll() async {
    return storage;
  }
}