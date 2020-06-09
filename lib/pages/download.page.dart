import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typeweight/typeweight.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hlsd/helpers/helpers.dart';
import 'package:hlsd/database/database.dart';
import 'package:hlsd/helpers/download_queue.dart';
import 'package:hlsd/components/action_button.dart';
import 'package:hlsd/helpers/no_scrollglow_behavior.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  TextEditingController _controller;
  FocusNode _focusNode;
  bool isDownloading = false;
  Map qualities = {};
  String quality;

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
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(
                      NavigationToolbar.kMiddleSpacing,
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                    ),
                  ),
                  if (qualities.length > 0)
                    Padding(
                      padding: const EdgeInsets.all(
                        NavigationToolbar.kMiddleSpacing,
                      ),
                      child: Text(
                        'Qualities',
                        style: GoogleFonts.ubuntuMono(
                          fontSize:
                              Theme.of(context).textTheme.subtitle1.fontSize,
                          fontWeight: TypeWeight.bold,
                        ),
                      ),
                    ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: NoScrollGlowBehavior(),
                      child: ListView.separated(
                        separatorBuilder: (_, index) {
                          return Container(
                            height: 1,
                            color: Colors.grey[300],
                          );
                        },
                        itemBuilder: (ctx, index) {
                          return RadioListTile(
                            title: Text(qualities.entries.toList()[index].key),
                            value: qualities.entries.toList()[index].value,
                            groupValue: quality,
                            onChanged: (v) {
                              setState(() {
                                quality = v;
                              });
                            },
                          );
                        },
                        itemCount: qualities.length,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(
                      NavigationToolbar.kMiddleSpacing,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: quality == null
                          ? RaisedButton(
                              padding: const EdgeInsets.symmetric(
                                vertical:
                                    NavigationToolbar.kMiddleSpacing / 1.5,
                              ),
                              elevation: 0,
                              onPressed: () async {
                                final url = _controller.text;
                                try {
                                  final q = await loadFileMetadata(url);
                                  setState(() {
                                    qualities = q;
                                    quality = q.entries.first.value;
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text(
                                'Load Metadata',
                                style: GoogleFonts.ubuntuMono(
                                  fontWeight: TypeWeight.bold,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .fontSize,
                                ),
                              ),
                            )
                          : RaisedButton(
                              padding: const EdgeInsets.symmetric(
                                vertical:
                                    NavigationToolbar.kMiddleSpacing / 1.5,
                              ),
                              elevation: 0,
                              onPressed: () async {
                                final url = quality;

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
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .fontSize,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
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
