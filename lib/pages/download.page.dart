import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeweight/typeweight.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hlsd/helpers/helpers.dart';
import 'package:hlsd/database/database.dart';
import 'package:hlsd/helpers/download_queue.dart';
import 'package:hlsd/components/action_button.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  TextEditingController _controller;
  FocusNode _focusNode;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: !isDownloading
          ? Scaffold(
              appBar: AppBar(
                title: Text(
                  'Download New',
                  style: GoogleFonts.ubuntuMono(
                    fontWeight: TypeWeight.bold,
                  ),
                ),
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                leading: ActionButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back),
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
                          final url = _controller.text;
                          var currentRecord = (await db.getAllRecord())
                              .where((r) => r.url == url);

                          if (currentRecord.isEmpty) {
                            int id = await db.insertNewRecord(
                              Record(url: url, downloaded: 0),
                            );

                            DownloadQueue.add(() async {
                              await load(url, (progress) async {
                                await db.updateRecord(
                                  Record(id: id, downloaded: progress),
                                );
                              });
                            });
                          }
                          Get.back();
                        },
                        child: Text(
                          'Download',
                          style: GoogleFonts.ubuntuMono(
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
