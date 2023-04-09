import 'package:crudrestapiwithdb/sqdb/sq.dart';
import 'package:flutter/material.dart';

class SQLITEDBSCREEN extends StatefulWidget {
  const SQLITEDBSCREEN({Key? key}) : super(key: key);

  @override
  State<SQLITEDBSCREEN> createState() => _SQLITEDBSCREENState();
}

class _SQLITEDBSCREENState extends State<SQLITEDBSCREEN> {
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  void refreshData() async {
    final data = await SQLHelper.getData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> _createData() async {
    await SQLHelper.createData(_capController.text, _descController.text);
    refreshData();
  }

  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, _capController.text, _descController.text);
    refreshData();
  }

  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    refreshData();
  }

  final TextEditingController _capController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
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
                if (id == null) {
                  await _createData();
                }
                if (id != null) {
                  await _updateData(id);
                }
                _capController.text = '';
                _descController.text = '';
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  id == null ? 'Add' : 'Update',
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
      backgroundColor: Colors.amberAccent,
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
                            showBottomSheet(_allData[index]['id']);
                          },
                          icon: const Icon(Icons.edit),
                          color: Colors.indigo,
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteData(_allData[index]['id']);
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
