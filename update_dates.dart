import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList();
  
  for (var file in files) {
    String content = file.readAsStringSync();
    String newContent = content;

    // Replace DateFormat('dd/MM/yyyy').format(
    newContent = newContent.replaceAll("DateFormat('dd/MM/yyyy').format", "DateFormat('dd MMM yyyy').format");
    
    // Replace DateFormat('dd/MM/yyyy, h:mm a').format(
    newContent = newContent.replaceAll("DateFormat('dd/MM/yyyy, h:mm a').format", "DateFormat('dd MMM yyyy, h:mm a').format");

    // Replace DateFormat('d MMM yyyy, hh:mm a').format(
    newContent = newContent.replaceAll("DateFormat('d MMM yyyy, hh:mm a').format", "DateFormat('dd MMM yyyy, hh:mm a').format");
    
    if (content != newContent) {
      file.writeAsStringSync(newContent);
      print('Updated: ${file.path}');
    }
  }
}
