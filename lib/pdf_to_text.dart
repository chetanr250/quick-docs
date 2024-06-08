import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lemmatizerx/lemmatizerx.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:stemmer/PorterStemmer.dart';
import 'package:stemmer/SnowballStemmer.dart';
import 'package:tokenizer/tokenizer.dart';

class PdfToText extends StatefulWidget {
  const PdfToText();

  @override
  State<PdfToText> createState() => _PdfToTextState();
}

class _PdfToTextState extends State<PdfToText> {
  String text = '';

  void lemma(listText) {
    print('lemma function');
    Lemmatizer lemmatizer = Lemmatizer();
    // print(listText);
    Set<String> lemmaList = {};
    for (var i = 0; i < listText.length; i++) {
      lemmaList.add(listText[i].toString().trim().toLowerCase());
      SnowballStemmer stemmer = SnowballStemmer();
      lemmaList.add(stemmer.stem(listText[i])); // outputs: Run
      // print(object)
      continue;
      List<Lemma> lemmasTemp = lemmatizer.lemmas(listText[i]);
      // print(lemmasTemp);
      for (var i = 0; i < lemmasTemp.length; i++) {
        // lemmasTemp.expand((element) => element.lemma).toList();

        lemmaList.add(lemmasTemp[0].form);
      }
    }
    print(lemmaList.join(' '));
    // List<Lemma> lemmas = lemmatizer.lemmas('meeting');
  }

  Future<void> extractText() async {
    // TODO: Replace with your PDF file path
    String pdfPath =
        "/Users/chetanr/Library/Developer/CoreSimulator/Devices/5CBB732B-6557-42E0-BEA6-687D1B4DE80E/data/Containers/Data/Application/B9B0F9F6-0035-41F0-9118-F15CB72FE949/tmp/Certificate.pdf";

    PDFDoc doc = await PDFDoc.fromPath(pdfPath);
    String tempText = await doc.text;
    // setState(() {
    text = tempText;
    // });
    // print(text);
    tokenise(text);
  }

  tokenReturn(c, tokenizer) async {
    final x = await c.stream.transform(tokenizer.transformer).toList();
    return x;
  }

  Future<List<String>> tokenise(text) async {
    // final string = 'Hello, world';
    final tokenizer = Tokenizer({',', ' ', '[', '\n', ']', '(', ')', '{', '}'});
    final c = StreamController<String>();

    c.add(text);

    c.close();
    final tokens = await c.stream.transform(tokenizer.transformer).toList();

    tokens.removeWhere(
        (element) => element == '' || element == ' ' || element == ',');
    // print(tokens);
    lemma(tokens);
    return tokens;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Expanded(child: Text(text)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: extractText,
            child: const Text('Extract Text from PDF'),
          ),
        ],
      ),
    );
  }
}
