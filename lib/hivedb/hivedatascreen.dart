import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveDataScreen extends StatefulWidget {
  const HiveDataScreen({Key? key}) : super(key: key);

  @override
  State<HiveDataScreen> createState() => _HiveDataScreenState();
}

class _HiveDataScreenState extends State<HiveDataScreen> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;
  final crudBox = Hive.box('crud');

  final TextEditingController _capController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    final data = crudBox.keys.map((key) {
      final item = crudBox.get(key);
      return {"key": key, "cap": item["cap"], "desc": item["desc"]};
    }).toList();
    setState(() {
      _allData = data.reversed.toList();
      _isLoading = false;
    });
  }

  Future<void> _createData(Map<String, dynamic> newData) async {
    await crudBox.add(newData);
    refreshData();
  }

  Future<void> _updateData(int itemKey, Map<String, dynamic> item) async {
    await crudBox.put(itemKey, item);
    refreshData();
  }

  void _deleteData(int itemKey) async {
    await crudBox.delete(itemKey);
    refreshData();
  }

  void showBottomSheet(int? itemKey) async {
    if (itemKey != null) {
      final existingData =
          _allData.firstWhere((element) => element['key'] == itemKey);
      _capController.text = existingData['cap'];
      _descController.text = existingData['desc'];
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 5,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _capController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (itemKey == null) {
                  await _createData({
                    "cap": _capController.text.trim(),
                    "desc": _descController.text.trim()
                  });
                }
                if (itemKey != null) {
                  await _updateData(itemKey, {
                    "cap": _capController.text.trim(),
                    "desc": _descController.text.trim()
                  });
                }
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  itemKey == null ? 'Add' : 'Update',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        title: const Text('CRUD'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _allData.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        _allData[index]['cap'],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        _allData[index]['desc'],
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showBottomSheet(_allData[index]['key']);
                          },
                          icon: const Icon(Icons.edit),
                          color: Colors.indigo,
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteData(_allData[index]['key']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Deleted'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.redAccent,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _capController.text = '';
          _descController.text = '';
          showBottomSheet(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
