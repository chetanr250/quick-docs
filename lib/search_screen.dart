import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:gap/gap.dart';
import 'package:pdf_made_easy/pdf_viewer.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({required this.controller});
  TextEditingController controller;

  @override
  State<SearchScreen> createState() => _SearchSearchState();
}

class _SearchSearchState extends State<SearchScreen> {
  late FocusNode myFocusNode;
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  String email = 'chetan250204@gmail.com';
  List<Map<String, dynamic>> listTileObjects = [];

  void searchLemma(words) async {
    var lemmaObj =
        await FirebaseFirestore.instance.collection('lemma').doc(email).get();
    words = words.map((e) => e.toString().toLowerCase()).toList();
    List<dynamic> data = lemmaObj.data()?['data'] ?? [];
    List<Map<String, dynamic>> filteredPDF = [];
    for (var i = 0; i < data.length; i++) {
      int flag = 0;
      for (var j = 0; j < words.length; j++) {
        if (data[i]['lemma'] != null && !data[i]['lemma']!.contains(words[j])) {
          flag = 1;
          break;
        }
      }
      if (flag == 0) {
        filteredPDF.add(data[i]);
        print(data[i]['folder']);
        print(data[i]['path']);
      }
    }
    // print(filteredPDF);
    setState(() {
      listTileObjects = filteredPDF;
    });
    // print()
    // return filteredPDF;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myFocusNode = FocusNode();

    // Use a post frame callback to focus on the TextField
    // after the UI has been rendered.
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(myFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magic search'),
      ),
      body: Column(
        children: [
          // DropzoneView(
          //   operation: DragOperation.copy,
          //   cursor: CursorType.grab,
          //   // onCreated: (DropzoneViewController ctrl) => controller = ctrl,
          //   onLoaded: () => print('Zone loaded'),
          //   onError: (String? ev) => print('Error: $ev'),
          //   onHover: () => print('Zone hovered'),
          //   onDrop: (dynamic ev) => print('Drop: $ev'),
          //   // onDropMultiple: (List<dynamic!> ev) => print('Drop multiple: ${ev!}'),
          //   onLeave: () => print('Zone left'),
          // ),
          Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 15, top: 2, bottom: 2),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: myFocusNode,
                    cursorRadius: const Radius.circular(40),
                    decoration: const InputDecoration(icon: Icon(Icons.search)),
                    controller: widget.controller,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      List<String> words = widget.controller.text.split(' ');
                      FocusScope.of(context).unfocus();
                      searchLemma(words);
                    },
                    child: const Text('Search'))
              ],
            ),
          ),
          const Gap(10),
          // if (listTileObjects.length != 0)
          Expanded(
            child: ListView.builder(
              itemCount: listTileObjects.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    PdfViewer(
                      fileName: listTileObjects[index]['name']!,
                      path: listTileObjects[index]['path']!,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfViewer(
                                  fileName: listTileObjects[index]['name']!,
                                  path: listTileObjects[index]['path']!,
                                ),
                              ),
                            );
                            // PdfViewer(
                            //   fileName: listTileObjects[index]['name']!,
                            //   path: listTileObjects[index]['path']!,
                            // );
                          },
                          child: ListTile(
                            leading: const Icon(Icons.file_open_outlined),
                            title: Text(listTileObjects[index]['name']!),
                            subtitle:
                                Text('${listTileObjects[index]['folder']}'),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
