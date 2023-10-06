import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'side_menu.dart';
import 'tambah_data.dart';
import 'update_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListData extends StatefulWidget {
  const ListData({super.key});
  @override
// ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataPekerjaan = [];
  String url = Platform.isAndroid
      ? 'http://192.168.116.191/api_flutter/index.php'
      : 'http://localhost/api_flutter/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  lihatMahasiswa(String nama , String status) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Nama Pekrjaan : $nama"),
              content: Text("Status Pekerjaan : $status"));
        });
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataPekerjaan = List<Map<String, String>>.from(data.map((item) {
          return {
            'nama': item['nama'] as String,
            'status': item['status'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Pekerjaan'),
      ),
      drawer: const SideMenu(),
      body: Column(children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TambahData(url: url),
              ),
            );
          },
          child: const Text('Tambah Data Pekerjaan'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dataPekerjaan.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataPekerjaan[index]['nama']!),
                subtitle: Text('status: ${dataPekerjaan[index]['status']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        lihatMahasiswa(dataPekerjaan[index]['nama']!,
                            dataPekerjaan[index]['status']!);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateData(
                                id: dataPekerjaan[index]['id']!,
                                nama: dataPekerjaan[index]['nama']!,
                                status: dataPekerjaan[index]['status']!,
                                url: url),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteData(int.parse(dataPekerjaan[index]['id']!))
                            .then((result) {
                          if (result['pesan'] == 'berhasil') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Data berhasil di hapus'),
                                    content: const Text('ok'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ListData(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
