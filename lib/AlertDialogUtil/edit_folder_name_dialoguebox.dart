import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditFolderDialog extends StatefulWidget {
  EditFolderDialog(
      {required this.index, required this.folderName, required this.uid});
  String folderName;
  int index;
  String uid;
  // List<String> folders;
  @override
  _EditFolderDialogState createState() => _EditFolderDialogState();
}

class _EditFolderDialogState extends State<EditFolderDialog> {
  final email = 'chetan250204@gmail.com';
  TextEditingController _controller = TextEditingController();
  SharedPreferences? prefs;
  // List<String>? folders;
  // List<String>? folderColors;

  Color colorFromString(str) {
    if (str == 'b') {
      return Colors.blue;
    } else if (str == 'g') {
      return Colors.green;
    } else if (str == 'r') {
      return Colors.red;
    } else if (str == 'y') {
      return Colors.yellow;
    }
    return Colors.blue;
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    // setState(() {
    // folders = prefs?.get('folders') as List<String> ?? [];
    // folderColors = prefs?.get('folderColors') as List<String> ?? [];
    // _selectedColor = colorFromString(
    //     (prefs!.get('folderColors') as List<String>)[widget.index]);
    setState(() {
      _controller = TextEditingController(text: widget.folderName);
    });
    // });
    // print(folders);
    print('inside');
  }

  @override
  void initState() {
    // TODO: implement initState
    initPrefs();
    _controller = TextEditingController(text: widget.folderName);
    super.initState();
  }

  Color _selectedColor = Colors.blue;

  @override
  // void initState() {
  //   super.initState();
  //   _selectedColor = colorFromString((prefs!.get('folderColors') as List<String>)[widget.index]);
  // }

  @override
  Widget build(BuildContext context) {
    void snack(text, {color = null, textColor = null}) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: color,
          content: Text(text, style: TextStyle(color: textColor)),
        ),
      );
    }

    return AlertDialog(
      title: const Text('Edit folder name'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.text,
            autocorrect: true,
            textCapitalization: TextCapitalization.sentences,
            // onChanged: (value) {
            //   FirebaseFirestore.instance
            //       .collection(email)
            //       .doc(widget.folderName)
            //       .update({
            //     'folderName': value,
            //   });
            //   // folders?[widget.index] =
            //   //     value; // Update the folderName whenever the user types
            // },
            decoration: InputDecoration(
              icon: Icon(
                Icons.folder_outlined,
                color: _selectedColor,
              ),
              hintText: "Folder name",
              border: const OutlineInputBorder(),
            ),
          ),
          const Gap(10),
          ElevatedButton(
            onPressed: () {
              // print('delete');
              snack('Folder deleted',
                  color: Colors.red, textColor: Colors.white);
              Navigator.of(context).pop();
              FirebaseFirestore.instance
                  .collection(email)
                  .doc(widget.uid)
                  .delete();
              // Navigator.of(context).pop();
              return;
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                          'Are you sure you want to delete the folder?'),
                      content: const Text(
                          'This will delete all the notes in the folder'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection(email)
                                .doc(widget.uid)
                                .delete();
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                return Colors.red;
                              },
                            ),
                            side:
                                MaterialStateProperty.resolveWith<BorderSide?>(
                              (Set<MaterialState> states) {
                                return BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                );
                              },
                            ),
                          ),
                          child: const Text(
                            'Delete Folder',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  });

              // FirebaseFirestore.instance
              //     .collection(email)
              //     .doc(widget.uid)
              //     .delete();
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return Colors.red;
                },
              ),
              side: MaterialStateProperty.resolveWith<BorderSide?>(
                (Set<MaterialState> states) {
                  return BorderSide(
                    color: Colors.white,
                    width: 1,
                  );
                },
              ),
            ),
            child: const Text(
              'Delete Folder',
              style: TextStyle(color: Colors.white),
            ),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: <Color>[
          //     Colors.red,
          //     Colors.green,
          //     Colors.blue,
          //     Colors.yellow,
          //   ].map((Color color) {
          //     return GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           _selectedColor = color;
          //         });
          //         // widget.index = folders!.indexOf(folders![widget.index]);
          //       },
          //       child: Container(
          //         width: 30,
          //         height: 30,
          //         decoration: BoxDecoration(
          //           color: color,
          //           shape: BoxShape.circle,
          //           border: Border.all(
          //             color: _selectedColor == color
          //                 ? Colors.white
          //                 : Colors.transparent,
          //             width: 3,
          //           ),
          //         ),
          //       ),
          //     );
          //   }).toList(),
          // ),
        ],
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
            // if (folders?[widget.index].trim() == '') {
            //   snack('Folder name cannot be empty',
            //       context: context, color: Colors.red, textColor: Colors.white);
            // ScaffoldMessenger.of(
            //         context)
            //     .clearSnackBars();
            // ScaffoldMessenger.of(
            //         context)
            //     .showSnackBar(
            //   const SnackBar(
            //     backgroundColor:
            //         Colors.red,
            //     content: Text(
            //         'Folder name cannot be empty',
            //         style: TextStyle(
            //             color: Colors
            //                 .white)),
            //   ),
            // );
            //   return;
            // }

            // if (folders!.contains(folders?[widget.index].trim())) {
            //   snack('Folder already exists',
            //       context: context, color: Colors.red, textColor: Colors.white);
            //   // ScaffoldMessenger.of(
            //   //         context)
            //   //     .showSnackBar(
            //   //   const SnackBar(
            //   //     backgroundColor:
            //   //         Colors.red,
            //   //     content: Text(
            //   //         'Folder already exists',
            //   //         style: TextStyle(
            //   //             color: Colors
            //   //                 .white)),
            //   // ),
            //   // );
            //   return;
            // }
            // setState(() {
            //   folders![widget.index] = folders![widget.index].trim();
            // });

            Navigator.of(context).pop();
            await FirebaseFirestore.instance
                .collection(email)
                .doc(widget.uid)
                .update({
              'folder': _controller.text,
              // 'folderColor': _selectedColor.toString(),
            });
          },
        ),
      ],
    );

    // AlertDialog(
    //   title: const Text('Edit folder name'),
    //   content: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       TextField(
    //         controller: _controller,
    //         keyboardType: TextInputType.text,
    //         // Other properties...
    //       ),
    //       // Other widgets...
    //     ],
    //   ),
    //   // Other properties...
    // );
  }
}
