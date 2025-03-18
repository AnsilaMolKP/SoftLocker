import 'package:flutter/material.dart';

class SaveAsDialog extends StatefulWidget {
  const SaveAsDialog({Key? key}) : super(key: key);

  @override
  _SaveAsDialogState createState() => _SaveAsDialogState();
}

class _SaveAsDialogState extends State<SaveAsDialog> {
  final TextEditingController _fileNameController =
      TextEditingController(text: 'Birth certificate');
  String _selectedFolder = 'Education/personal/...';

  void _clearFileName() {
    _fileNameController.clear();
  }

  Future<void> _pickFolder() async {
    // Simulating folder selection
    String? selectedFolder = await showDialog<String>(
      context: context,
      builder: (context) => FolderPickerDialog(),
    );

    if (selectedFolder != null) {
      setState(() {
        _selectedFolder = selectedFolder;
      });
    }
  }

  void _saveFile() {
    Navigator.of(context).pop({
      'fileName': _fileNameController.text,
      'folder': _selectedFolder,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Save AS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // File name input
            TextField(
              controller: _fileNameController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearFileName,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Folder selection
            InkWell(
              onTap: _pickFolder,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.folder, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Folder: $_selectedFolder',
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: _saveFile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Folder Picker Dialog
class FolderPickerDialog extends StatelessWidget {
  final List<String> folders = [
    'Education',
    'Medical',
    'ID Cards',
    'Vehicle',
    'Certificates',
    'Assets',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Folder"),
      content: SizedBox(
        height: 200,
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: folders.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.folder, color: Colors.blue),
              title: Text(folders[index]),
              onTap: () {
                Navigator.of(context).pop(folders[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

// Main Example Usage
void main() {
  runApp(const MaterialApp(home: SaveAsDialogExample()));
}

class SaveAsDialogExample extends StatelessWidget {
  const SaveAsDialogExample({Key? key}) : super(key: key);

  void _openDialog(BuildContext context) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const SaveAsDialog(),
    );

    if (result != null) {
      print("File Name: ${result['fileName']}");
      print("Folder: ${result['folder']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Save As Dialog")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _openDialog(context),
          child: const Text("Open Dialog"),
        ),
      ),
    );
  }
}
