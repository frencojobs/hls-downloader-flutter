import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:typeweight/typeweight.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hlsd/helpers/helpers.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  TextEditingController _controller;
  FocusNode _focusNode;
  bool isDownloading = false;
  Box<String> downloads;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    downloads = Hive.box('downloads');
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: !isDownloading
          ? Scaffold(
              appBar: AppBar(
                title: Text(
                  'Download New',
                  style: GoogleFonts.workSans(
                    fontWeight: TypeWeight.bold,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(
                  NavigationToolbar.kMiddleSpacing,
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                    ),
                    SizedBox(
                      height: NavigationToolbar.kMiddleSpacing,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        elevation: 0,
                        onPressed: () async {
                          if (!downloads.values.contains(_controller.text)) {
                            setState(() {
                              isDownloading = true;
                            });

                            var fileLocation;

                            try {
                              fileLocation = await load(_controller.text);
                            } catch (e) {
                              print('Error:');
                              print(e);
                            }

                            if (fileLocation != null) {
                              await downloads.add(_controller.text);
                            }

                            setState(() {
                              isDownloading = false;
                            });
                          }

                          Get.back();
                        },
                        child: Text(
                          'Download',
                          style: GoogleFonts.workSans(
                            fontWeight: TypeWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Scaffold(
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Downloading...')
                  ],
                ),
              ),
            ),
    );
  }
}
