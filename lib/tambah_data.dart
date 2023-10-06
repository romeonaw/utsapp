import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:utsapp/side_menu.dart';
import 'package:utsapp/list_data.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class TambahData extends StatefulWidget {
  String url;
  TambahData({super.key,required this.url});
  @override
  _TambahData createState() => _TambahData(url: url);
}

class _TambahData extends State<TambahData> {
  String url;
  _TambahData({required this.url});
  final _namaController = TextEditingController();
  final _statusController = TextEditingController();

  _buatInput(namacontroller, String hint) {
    return TextField(
      controller: namacontroller,
      decoration: InputDecoration(
        hintText: hint,
      ),
    );
  }

  Future<void> insertData(String nama, String status) async {
    final response = await http.post(Uri.parse(url),
      body: jsonEncode(<String, String>{
        'nama': nama,
        'status' : status
      }),
    );
    if(response.statusCode == 200){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => const ListData(),
        ),
      );
    }else{
      throw Exception('Failed to Insert Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Pekerjaan')
        ),
        drawer: const SideMenu(),
        body : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child : Column(
                  children: [
                    _buatInput(_namaController, 'Masukkan Nama Pekerjaan'),
                    _buatInput(_statusController, 'Masukkan Status'),
                  ],
                )
              ),
              ElevatedButton(
                child: const Text('Tambah Pekerjaan'),
                onPressed: () {
                  insertData(_namaController.text,_statusController.text);
                }
              )
            ]
          )
        );
  }
}