import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:utsapp/side_menu.dart';
import 'package:utsapp/list_data.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class UpdateData extends StatefulWidget {
  String id;
  String nama;
  String status;
  String url;
  UpdateData({super.key, required this.id, required this.nama, required this.status,required this.url});
  @override
  _UpdateData createState() => _UpdateData(url : url);
}

class _UpdateData extends State<UpdateData> {
  String url;
  _UpdateData({required this.url});
  final _namaController = TextEditingController();
  final _statusController = TextEditingController();

  _buatInput(namacontroller, String hint,String data) {
    namacontroller.text=data;
    return TextField(
      controller: namacontroller,
      decoration: InputDecoration(
        hintText: hint,
      ),
    );
  }

  Future<void> updateData(String nama, String status,String id) async {
    final response = await http.put(Uri.parse(url),
      body: jsonEncode(<String, String>{
        'id' : id,
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
      throw Exception('Failed to Update Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Edit Pekerjaan')
        ),
        drawer: const SideMenu(),
        body : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  child : Column(
                    children: [
                      _buatInput(_namaController, 'Masukkan Nama Pekerjaan',widget.nama),
                      _buatInput(_statusController, 'Masukkan Status',widget.status),
                    ],
                  )
              ),
              ElevatedButton(
                  child: const Text('Edit Mahasiswa'),
                  onPressed: () {
                    updateData(_namaController.text,_statusController.text,widget.id);
                  }
              )
            ]
        )
    );
  }
}