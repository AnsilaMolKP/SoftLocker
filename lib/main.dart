import 'package:flutter/material.dart';

// ------------------- Save As Dialog -------------------
class SaveAsDialog extends StatefulWidget {
  final Function(String, String) onSave;
  const SaveAsDialog({Key? key, required this.onSave}) : super(key: key);

  @override
  _SaveAsDialogState createState() => _SaveAsDialogState();
}

class _SaveAsDialogState extends State<SaveAsDialog> {
  final TextEditingController _fileNameController = TextEditingController();
  String _selectedFolder = "Education";

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
            const SizedBox(height: 16),

            // Text field for filename
            TextField(
              controller: _fileNameController,
              decoration: InputDecoration(
                hintText: 'Enter file name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _fileNameController.clear(),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Folder selection dropdown
            DropdownButtonFormField<String>(
              value: _selectedFolder,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: ["Education", "Medical", "ID Cards", "Vehicle", "Certificates"]
                  .map((folder) => DropdownMenuItem(
                        value: folder,
                        child: Text(folder),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedFolder = value);
                }
              },
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onSave(_fileNameController.text, _selectedFolder);
                    Navigator.of(context).pop();
                  },
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

// ------------------- Document List Page -------------------
class DocumentListPage extends StatefulWidget {
  const DocumentListPage({Key? key}) : super(key: key);

  @override
  _DocumentListPageState createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  final List<Map<String, dynamic>> folders = [
    {"name": "Education", "items": 54, "size": "223 MB"},
    {"name": "Medical", "items": 21, "size": "134 MB"},
    {"name": "ID Cards", "items": 15, "size": "98 MB"},
    {"name": "Vehicle", "items": 10, "size": "75 MB"},
    {"name": "Certificates", "items": 65, "size": "290 MB"},
  ];

  String _searchQuery = "";

  void _saveFile(String fileName, String folderName) {
    setState(() {
      // Find folder and update its count
      for (var folder in folders) {
        if (folder["name"] == folderName) {
          folder["items"] += 1;
        }
      }
    });

    // Show saving animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return const Center(
          child: SavingOverlay(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredFolders = folders.where((folder) {
      return folder["name"]!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Documents', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(icon: const Icon(Icons.account_circle, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search folders...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),

          // Folder List
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: filteredFolders.length,
              itemBuilder: (context, index) {
                var folder = filteredFolders[index];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.folder, size: 50, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text(folder["name"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("${folder["items"]} items - ${folder["size"]}", style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Floating Action Button to open Save As Dialog
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => SaveAsDialog(onSave: _saveFile),
          );
        },
        child: const Icon(Icons.add),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Folders'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// ------------------- Saving Overlay -------------------
class SavingOverlay extends StatelessWidget {
  const SavingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 120,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Saving...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: DocumentListPage()));
}
