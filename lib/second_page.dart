import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lemmatizerx/lemmatizerx.dart';
import 'package:pdf_made_easy/pdf_viewer.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:stemmer/stemmer.dart';
import 'package:tokenizer/tokenizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class SecondPage extends StatefulWidget {
  SecondPage({required this.uid});
  String uid;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final email = 'chetan250204@gmail.com';
  String text = '';
  dynamic firestoreData;
  String AppbarTitle = '';
  void fire() async {
    firestoreData = await FirebaseFirestore.instance
        .collection(email)
        .doc(widget.uid)
        .get();
    firestoreData = firestoreData.data();
    setState(() {
      AppbarTitle = firestoreData['folder'] ?? 'Files';
    });
    // print(firestoreData);
  }

  @override
  void initState() {
    // TODO: implement initState
    fire();
    super.initState();
  }

  Future<String> getTempDirectoryPath() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  Future<String> uploadPdf(String path) async {
    try {
      // Create a Reference to the file
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child('pdfs/${DateTime.now().toIso8601String()}.pdf');

      // Upload the file
      UploadTask uploadTask = ref.putFile(File(path));

      // Wait for the upload to complete
      await uploadTask.whenComplete(() => print('Upload complete.'));

      // Get the download URL
      String downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // e.g, e.toString()
      print('An error occurred while uploading the file.');
      throw e; // Re-throw the exception to allow calling code to handle it.
    }
  }
  // void uploadPdf(String path) async {
  //   try {
  //     // Create a Reference to the file
  //     FirebaseStorage storage = FirebaseStorage.instance;
  //     Reference ref = storage.ref().child('$email/${widget.uid}.pdf');

  //     // Upload the file
  //     UploadTask uploadTask = ref.putFile(File(path));

  //     // Optionally, wait for the upload to complete
  //     await uploadTask.whenComplete(() => print('Upload complete.'));
  //   } catch (e) {
  //     // e.g, e.toString()
  //     print('An error occurred while uploading the file.');
  //   }
  // }

  Future<String> pickFileAndStoreInTemp() async {
    // Pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);

    if (result != null) {
      File file = File(result.paths.single!);
      print(file.path);
      // File file = File(result.files.single.path!);
      // Get the temporary directory
      // Directory tempDir = await getTemporaryDirectory();

      // File tempFile = await file.copy('${tempDir.path}');

      ///${file.basename}

      // Return the path of the file in the temporary directory
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => PdfViewer(file.path),
      //     ));
      // PdfViewer()
      String path = file.path;
      return path;
    } else {
      // User canceled the picker
      throw Exception('No file selected.');
    }
  }

  Future<Set<String>> extractText(path) async {
    // TODO: Replace with your PDF file path
    // String path =
    //     "/Users/chetanr/Library/Developer/CoreSimulator/Devices/5CBB732B-6557-42E0-BEA6-687D1B4DE80E/data/Containers/Data/Application/B9B0F9F6-0035-41F0-9118-F15CB72FE949/tmp/Certificate.pdf";

    PDFDoc doc = await PDFDoc.fromPath(path);
    String tempText = await doc.text;
    // setState(() {
    text = tempText;
    // });
    // print(text);
    return tokenise(text);
  }

  tokenReturn(c, tokenizer) async {
    final x = await c.stream.transform(tokenizer.transformer).toList();
    return x;
  }

  Future<Set<String>> tokenise(text) async {
    // final string = 'Hello, world';
    final tokenizer = Tokenizer({',', ' ', '[', '\n', ']', '(', ')', '{', '}'});
    final c = StreamController<String>();

    c.add(text);

    c.close();
    final tokens = await c.stream.transform(tokenizer.transformer).toList();

    tokens.removeWhere(
        (element) => element == '' || element == ' ' || element == ',');
    // print(tokens);

    return lemma(tokens);
    tokens;
  }

  Set<String> lemma(listText) {
    print('lemma function');
    Lemmatizer lemmatizer = Lemmatizer();
    // print(listText);
    Set<String> lemmaList = {};
    for (var i = 0; i < listText.length; i++) {
      lemmaList.add(listText[i].toString().trim().toLowerCase());
      SnowballStemmer stemmer = SnowballStemmer();
      lemmaList.add(stemmer.stem(listText[i])); // outputs: Run
      // print(object)

      // continue;
      List<Lemma> lemmasTemp = lemmatizer.lemmas(listText[i]);
      // print(lemmasTemp);
      for (var i = 0; i < lemmasTemp.length; i++) {
        // lemmasTemp.expand((element) => element.lemma).toList();

        lemmaList.add(lemmasTemp[0].form);
      }
    }
    return lemmaList;
    print(lemmaList.join(' '));
    // List<Lemma> lemmas = lemmatizer.lemmas('meeting');
  }

  String getFileName(String path) {
    return p.basename(path);
  }

  Future<void> deleteFile(String downloadUrl) async {
    try {
      // Create a Reference to the file
      Reference ref = FirebaseStorage.instance.refFromURL(downloadUrl);

      // Delete the file
      await ref.delete();

      print('File deleted.');
    } catch (e) {
      // e.g, e.toString()
      print('An error occurred while deleting the file.');
      throw e; // Re-throw the exception to allow calling code to handle it.
    }
  }

  String uploadingString = '';
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppbarTitle),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          print('Started');
          setState(() {
            isUploading = true;
            uploadingString = 'Getting started';
          });
          String path1 = await pickFileAndStoreInTemp();
          print('stored in path');
          setState(() {
            // isUploading = false;
            uploadingString = 'Processing the text';
          });
          Set<String> lemma = await extractText(path1);
          print('lemma done');
          setState(() {
            // isUploading = false;
            uploadingString = 'Uploading the file to cloud!';
          });
          String downloadUrl = await uploadPdf(path1);
          setState(() {
            isUploading = false;
          });
          print('downloadUrl done');
          TextEditingController controller =
              TextEditingController(text: getFileName(path1));
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Name your Document'),
                  content: Container(
                    child: TextField(
                      controller: controller,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        deleteFile(downloadUrl);
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection(email)
                            .doc(widget.uid)
                            .set({
                          'files': FieldValue.arrayUnion([
                            {
                              'name': controller.text,
                              'path': downloadUrl,
                              'lemma': lemma.toList()
                            }
                          ])
                        }, SetOptions(merge: true));

                        await FirebaseFirestore.instance
                            .collection('lemma')
                            .doc(email)
                            .set({
                          'data': FieldValue.arrayUnion([
                            {
                              'folder': AppbarTitle,
                              'name': controller.text,
                              'path': downloadUrl,
                              'lemma': lemma.toList(),
                              // .map(
                              //   (e) => lemma
                              //       .map((e) =>
                              //           jsonDecode(e) as Map<String, String>)
                              //       .toList(),
                              // ),
                            }
                          ])
                        }, SetOptions(merge: true));
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                );
              });
          // showDialog(
          //     builder: (context) {
          //       return AlertDialog(
          //         title: Text('Enter the name of the file'),
          //         content: TextField(
          //           controller: TextEditingController(),
          //         ),
          //         actions: [
          //           TextButton(onPressed: () {}, child: Text('Cancel')),
          //           TextButton(onPressed: () {}, child: Text('Save')),
          //         ],
          //       );
          //     },
          //     context: context);
        },
      ),
      // },) ,
      body: !isUploading
          ? firestoreData['files'] != null
              ? ListView.builder(
                  itemCount: firestoreData['files'].length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color.fromARGB(65, 33, 149, 243),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const Icon(Icons.file_open_outlined),
                          title: Text(
                            firestoreData['files'][index]['name'],
                            style: const TextStyle(fontSize: 20),
                          ),
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfViewer(
                                  path: firestoreData['files'][index]['path'],
                                  fileName: firestoreData['files'][index]
                                      ['name'],
                                ),
                              ),
                            );
                            // PdfViewer(firestoreData['files'][index]['path']);
                            // )

                            // )

                            // extractText(firestoreData['files'][index]['path']);
                          },
                        ),
                      ),
                    );
                    // return null;
                  })
              // StreamBuilder(
              //   stream: firestoreData,
              //   // FirebaseFirestore.instance
              //   //     .collection(email)
              //   //     .doc(widget.uid)
              //   //     .snapshots(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }

              //     print(snapshot.data);
              //     return Center(
              //       child: Text('snapshot.data![].length.toString()'),
              //     );
              //     return Column(
              //       children: [
              //         // for (var i in snapshot.data!['files'].length)
              //         ListTile(
              //           title: Text('i'),
              //         ),
              //         // Text(snapshot.data['name']),
              //         // Text(snapshot.data['email']),
              //       ],
              //     );
              //     // ListView.builder(
              //     //   itemCount: snapshot.data.docs.length,
              //     //   itemBuilder: (context, index) {
              //     //     return ListTile(
              //     //       title: Text(snapshot.data.docs[index]['name']),
              //     //     );
              //     //   },
              //     // );
              //   },
              // ),
              : const Center(
                  child: Text(
                      'No files found. Please upload a file to view it here.'))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const Gap(8),
                  Text(uploadingString),
                ],
              ),
            ),
    );
  }
}
