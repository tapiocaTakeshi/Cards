import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cards/ExtructProfilePage.dart';
import 'package:cards/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

enum FrontOrBack { Front, Back }

class _AddPageState extends State<AddPage> {
  File? _fileFront;
  File? _fileBack;
  final currentUid = FirebaseAuth.instance.currentUser!.uid;
  late String id;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = generateRandomString();
    print(id);
  }

  String generateRandomString([int length = 20]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz_';
    final Random random = Random.secure();
    final String randomStr =
        List.generate(length, (_) => charset[random.nextInt(charset.length)])
            .join();
    return randomStr;
  }

  Future ImageScan(FrontOrBack frontOrBack) async {
    try {
      final ref = FirebaseStorage.instance
          .ref(currentUid + '/' + id + '/' + frontOrBack.name + '.png');
      final docref = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUid)
          .collection('Cards')
          .doc(id);
      await docref.set({'file': 'gs://${ref.bucket}/${ref.fullPath}'},
          SetOptions(merge: true));
      final uploadTask = await ref.putFile(
          frontOrBack == FrontOrBack.Front ? _fileFront! : _fileBack!,
          SettableMetadata(contentType: 'image/png'));
      final url = await uploadTask.ref.getDownloadURL();
      await docref.update({'cardImage' + frontOrBack.name: url});
      await Future.delayed(Duration(seconds: 15));

      final snapshot = await docref.get();
      final jsonString = snapshot
              .data()!['output' + frontOrBack.name]
              .toString()
              .contains('json')
          ? snapshot
              .data()!['output' + frontOrBack.name]
              .toString()
              .replaceAll('\`\`\`', '')
              .split('json')[1]
          : '${snapshot.data()!['output' + frontOrBack.name]}';
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      await docref
          .update({'json' + frontOrBack.name: jsonMap, 'date': DateTime.now()});
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFinish = _fileFront != null && _fileBack != null;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                _fileFront = await DocumentScannerFlutter.launch(context,
                    source: ScannerFileSource.CAMERA);
                setState(() {});
              },
              child: SizedBox(
                  width: 91 * 4,
                  height: 55 * 4,
                  child: Card(
                    child: _fileFront != null
                        ? Image.file(_fileFront!)
                        : Container(
                            child: Center(
                                child: Text(
                              'Front',
                              style: Theme.of(context).textTheme.displayMedium,
                            )),
                          ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                _fileBack = await DocumentScannerFlutter.launch(context,
                    source: ScannerFileSource.CAMERA);
                setState(() {});
              },
              child: SizedBox(
                  width: 91 * 4,
                  height: 55 * 4,
                  child: Card(
                    child: _fileBack != null
                        ? Image.file(_fileBack!)
                        : Container(
                            child: Center(
                                child: Text(
                              'Back',
                              style: Theme.of(context).textTheme.displayMedium,
                            )),
                          ),
                  )),
            ),
          ),
          SizedBox(height: 200),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  enableFeedback: !isFinish,
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.white,
                  disabledForegroundColor: Colors.deepPurpleAccent,
                  fixedSize: Size(350, 50)),
              onPressed: isFinish
                  ? () async {
                      setState(() {
                        isLoading = true;
                      });
                      await ImageScan(FrontOrBack.Front);

                      await ImageScan(FrontOrBack.Back);
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ExtructProfilePage(id)));
                    }
                  : null,
              child:
                  isLoading ? CircularProgressIndicator.adaptive() : Text('次へ'))
        ],
      )),
    );
  }
}
