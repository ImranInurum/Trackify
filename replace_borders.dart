import 'dart:io';

void main() {
  final dir = Directory('lib');
  int filesFixed = 0;
  
  for (final file in dir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      String content = file.readAsStringSync();
      bool modified = false;
      
      if (content.contains('border: Border.all(color: theme.dividerColor, width: 1)')) {
        content = content.replaceAll('border: Border.all(color: theme.dividerColor, width: 1)', 'border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5)');
        modified = true;
      }
      
      if (content.contains('border: Border.all(color: Theme.of(context).dividerColor, width: 1)')) {
        content = content.replaceAll('border: Border.all(color: Theme.of(context).dividerColor, width: 1)', 'border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5)');
        modified = true;
      }
      
      if (modified) {
        file.writeAsStringSync(content);
        print('Updated border in: ${file.path}');
        filesFixed++;
      }
    }
  }
  
  print('Total files updated: $filesFixed');
}
