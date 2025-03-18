import 'package:flutter/material.dart';

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
    {"name": "Assets", "items": 8, "size": "120 MB"},
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredFolders = folders.where((folder) {
      return folder["name"]!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Documents',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
                  onTap: () {
                    _showFolderOptions(context, folder["name"]);
                  },
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
                        Text(
                          folder["name"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text("${folder["items"]} items - ${folder["size"]}",
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Show Folder Options
  void _showFolderOptions(BuildContext context, String folderName) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                folderName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text("Share"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.drive_file_rename_outline),
                title: const Text("Rename"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.folder_open),
                title: const Text("Move"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete", style: TextStyle(color: Colors.red)),
                onTap: () {
                  setState(() {
                    folders.removeWhere((folder) => folder["name"] == folderName);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DocumentListPage(),
  ));
}
