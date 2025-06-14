import 'dart:convert';
import 'package:flutter/material.dart';
import 'data_fetcher.dart';
import 'package:http/http.dart' as http;

class ViewActivePOCScreen extends StatelessWidget {
  const ViewActivePOCScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchAndMergeData() async {
    try {
      List<dynamic> data = await DataFetcher().fetchMergedData();

      if (data.isEmpty) {
        print('No data received');
        return [];
      }

      final uniqueData = data
          .cast<Map<String, dynamic>>()
          .fold<List<Map<String, dynamic>>>([], (previousValue, element) {
        if (previousValue.any((e) => e['email'] == element['email'])) {
          return previousValue;
        } else {
          return [...previousValue, element];
        }
      });

      return uniqueData;
    } catch (e) {
      print('Error fetching and merging data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disables automatic back button
        backgroundColor: const Color(0xFF6CBCFB),
        toolbarHeight: 140,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // Navigate back to CollegePOCManagementScreen
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Active College\n        POCs',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'KronaOne',
          ),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 370,
                  child: ContainerManager(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(),
                        child: CollegePOCList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerManager extends StatelessWidget {
  final List<Widget> children;

  const ContainerManager({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: 370,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

class CollegePOCList extends StatefulWidget {
  const CollegePOCList({super.key});

  @override
  _CollegePOCListState createState() => _CollegePOCListState();
}

class _CollegePOCListState extends State<CollegePOCList> {
  List<dynamic> pocs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPOCs();
  }

  Future<void> fetchPOCs() async {
    try {
      var url = 'http://localhost/poc_head/poc/fetch_poc.php';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body);
        if (decodedJson is List) {
          setState(() {
            pocs = decodedJson;
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        throw Exception('Failed to load POCs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load POCs: $e')),
      );
    }
  }

  Future<void> _deletePOC(String id) async {
    try {
      var url = 'http://localhost/poc_head/poc/delete_active_poc.php';
      var response = await http.post(
        Uri.parse(url),
        body: {'id': id},
      );

      if (response.statusCode == 200) {
        fetchPOCs();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('POC deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete POC: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete POC: $e')),
      );
    }
  }

  Future<void> _editPOC(String id, String name, String email) async {
    try {
      var url = 'http://localhost/poc_head/poc/edit_active_poc.php';
      var response = await http.post(
        Uri.parse(url),
        body: {
          'id': id,
          'name': name,
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        fetchPOCs();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('POC updated successfully')),
        );
      } else {
        throw Exception('Failed to edit POC: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to edit POC: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : pocs.isEmpty
            ? const Center(child: Text('No POCs found'))
            : Column(
                children: [
                  for (var poc in pocs)
                    ExpansionPanelWidget1(
                      id: poc['id'].toString(),
                      name: poc['name'] ?? 'No Name',
                      email: poc['email'] ?? 'No Email',
                      onDelete: () => _deletePOC(poc['id'].toString()),
                      onEdit: (name, email) => _editPOC(
                        poc['id'].toString(),
                        name,
                        email,
                      ),
                    ),
                ],
              );
  }
}

class ExpansionPanelWidget1 extends StatelessWidget {
  final String id;
  final String name;
  final String email;
  final VoidCallback onDelete;
  final Function(String, String) onEdit;

  const ExpansionPanelWidget1({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ListTile(
        title: ExpansionTile(
          title: Text(
            name,
            style: const TextStyle(
              fontFamily: 'Poppins-SemiBold',
            ),
          ),
          leading: Image.asset(
            'icons/down-button.png',
            width: 30,
            height: 30,
            color: const Color(0xFF0187F1),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Name: ',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Email: ',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Action(s): ',
                        style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 10,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showEditDialog(context);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 4),
                            Text('Edit',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Poppins-Regular',
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: onDelete,
                        child: const Row(
                          children: [
                            Icon(Icons.delete, size: 20),
                            SizedBox(width: 4),
                            Text('Delete',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Poppins-Regular',
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController _nameController =
        TextEditingController(text: name);
    final TextEditingController _emailController =
        TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Active POC'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onEdit(
                  _nameController.text,
                  _emailController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
