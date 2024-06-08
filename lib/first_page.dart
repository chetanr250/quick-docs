import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf_made_easy/search_screen.dart';
import 'package:pdf_made_easy/second_page.dart';
import 'package:uuid/uuid.dart';
import 'package:pdf_made_easy/AlertDialogUtil/edit_folder_name_dialoguebox.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  const FirstPage();

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String email = 'chetan250204@gmail.com';
  void fromFire() async {
    final collection =
        await firestore.collection('chetan250204@gmail.com').get();
    // print(collection);
    // folders =
  }
  // void addFire(doc){
  //   firestore.collection(email).
  // }

  void snack(text, {color = null, context, textColor = null}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(text, style: TextStyle(color: textColor)),
      ),
    );
  }

  List<String> folders = [];
  TextEditingController searchController = TextEditingController();

  SharedPreferences? prefs;

  void initPrefs() async {
    // print('init');
    prefs = await SharedPreferences.getInstance();
    fromFire();
    // var temp = objectToString(prefs!.get('folderColors')); // as List<String>;
    // List<Color> tempColor = [];
    // print(temp);
    // for (var i = 0; i < temp.length; i++) {
    //   tempColor.add(colorFromString(temp[i]));
    //   // if (temp[i] == 'b') {
    //   //   tempColor.add(Colors.blue);
    //   // } else if (temp[i] == 'g') {
    //   //   tempColor.add(Colors.green);
    //   // } else if (temp[i] == 'r') {
    //   //   tempColor.add(Colors.red);
    //   // } else if (temp[i] == 'y') {
    //   //   tempColor.add(Colors.yellow);
    //   // }
    // }
    // print(prefs?.get('folders'));
    // setState(() {
    //   folderColorsList = tempColor;
    //   folders = prefs?.get('folders') as List<String> ?? [];
    //   // folderColors = prefs?.get('folderColors') as List<String> ?? [];
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Folder'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String folderName = '';
              return AlertDialog(
                title: const Text('Enter folder name'),
                content: TextField(
                  keyboardType: TextInputType.text,
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) {
                    folderName =
                        value; // Update the folderName whenever the user types
                  },
                  decoration: const InputDecoration(
                    hintText: "Folder name",
                    border: OutlineInputBorder(),
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () async {
                      if (folderName.trim() == '') {
                        snack(
                          'Folder name cannot be empty',
                          context: context,
                          color: Colors.red,
                          textColor: Colors.white,
                        );
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     backgroundColor: Colors.red,
                        //     content: Text('Folder name cannot be empty',
                        //         style: TextStyle(color: Colors.white)),
                        //   ),
                        // );
                        return;
                      }

                      if (folders!.contains(folderName.trim())) {
                        snack('Folder already exists',
                            context: context,
                            color: Colors.red,
                            textColor: Colors.white);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     backgroundColor: Colors.red,
                        //     content: Text('Folder already exists',
                        //         style: TextStyle(color: Colors.white)),
                        //   ),
                        // );
                        return;
                      }
                      final uid = Uuid().v1();
                      Navigator.of(context).pop(); // Close the dialog
                      await firestore.collection(email).doc(uid).set({
                        'uid': uid,
                        'folder': folderName,
                        // 'folderColor': Colors.blue,
                      });
                      snack('Folder created',
                          context: context,
                          color: Colors.green,
                          textColor: Colors.white);
                      // setState(() {
                      // folders?.add(folderName
                      //     .trim()); // Add the folderName to the folders list
                      // folderColors.add('b');
                      // prefs?.setStringList('folders', folders);

                      // prefs?.setStringList('folderColors', folderColors);
                      // print(prefs?.get('folders'));
                      // });
                    },
                  ),
                ],
              );
            },
          );
          // setState(() {
          //   folders.add('folder4');
          // });
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const PdfViewer()),
          // );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(email).snapshots(),
        initialData: const CircularProgressIndicator(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return const Center(
              child: Text('No folders created'),
            );
          }
          return GestureDetector(
            onHorizontalDragDown: (details) {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      child: TextButton.icon(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          print('tap');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(
                                controller: searchController,
                              ),
                            ),
                          );
                        },
                        label: const Text('Search'),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          // border: Border.all(
                          //   color: Colors.black,
                          //   width: 1,
                          // ),
                          ),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height - 100,
                        maxWidth: MediaQuery.of(context).size.width - 30,
                      ), // 50 is padding,
                      child: snapshot.data.docs.length != 0
                          ? ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    print('came');

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SecondPage(
                                          uid: snapshot.data.docs[index]['uid'],
                                        ),
                                      ),
                                    );

                                    // print('tapped');
                                  },
                                  child: Card(
                                    shape: const RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Color.fromARGB(65, 33, 149, 243),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    color: Colors.blue.withOpacity(0.2),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                          leading: const Icon(
                                            Icons.folder_outlined,
                                            color: Colors.blue,
                                          ),
                                          title: Text(snapshot.data.docs[index]
                                              ['folder']),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              // color: snapshot.data.docs[index]
                                              //     ['folderColor'],
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  String folderName = '';
                                                  void t() async {
                                                    folderName = snapshot.data
                                                        .docs[index]['folder'];
                                                  }

                                                  t();
                                                  // TextEditingController
                                                  //     _controller =
                                                  //     TextEditingController(
                                                  //   text: folderName,
                                                  // );
                                                  return EditFolderDialog(
                                                    uid: snapshot.data
                                                        .docs[index]['uid'],
                                                    folderName: folderName,
                                                    // folders: folders,
                                                    index: index,
                                                  );
                                                },
                                              );
                                            },
                                          )),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text('No folders'),
                    ),

                    // Container(
                    //   constraints: const BoxConstraints(maxHeight: 500, maxWidth: 500),
                    //   child: const PdfViewer(),
                    // ),
                    // Text(
                    //   'Hello World',
                    // ),
                    // const SizedBox(
                    //   height: 500,
                    //   child: PdfToText(),
                    // ),
                    // ElevatedButton(
                    //   onPressed: pickPdf,
                    //   child: const Text('Pick a PDF'),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
