import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:typeweight/typeweight.dart';

import 'package:hlsd/pages/pages.dart';
import 'package:hlsd/database/database.dart';
import 'package:hlsd/helpers/helpers.dart';
import 'package:hlsd/helpers/download_queue.dart';
import 'package:hlsd/components/action_button.dart';

class DownloadsPage extends StatefulWidget {
  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final downloadStream = DownloadQueue.load();
    final dbStream = db.watchAllRecord();

    return StreamBuilder(
      stream: downloadStream,
      builder: (context, snapshot) {
        print('stream');
        print(snapshot.data);

        if (snapshot.hasData) {
          DownloadQueue.execute(snapshot.data);

          if (snapshot.data.isEmpty) {
            db.deleteUncompleteDownloads();
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Downloads',
              style: GoogleFonts.ubuntuMono(
                fontWeight: TypeWeight.bold,
              ),
            ),
            // actions: <Widget>[
            //   ActionButton(
            //     icon: Icon(Icons.play_circle_outline),
            //     onPressed: () async {
            //       print(DownloadQueue.queue);
            //       await DownloadQueue.execute(snapshot.data);

            //       print('finished download queue');
            //     },
            //   )
            // ],
          ),
          body: StreamBuilder(
            stream: dbStream,
            builder: (context, AsyncSnapshot<List<Record>> snapshot) {
              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Center(
                  child: Text(
                    'No Files Downloaded!',
                    style: GoogleFonts.ibmPlexMono(
                      fontStyle: FontStyle.italic,
                      fontSize: Theme.of(context).textTheme.headline6.fontSize,
                      fontWeight: TypeWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                );
              } else {
                final dls = snapshot.data;

                return ListView.builder(
                  itemCount: dls.length,
                  itemBuilder: (context, index) {
                    final record = dls[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                      child: ListTile(
                        enabled: record.downloaded >= 100,
                        onTap: () async {
                          final loc = await findFileLocation(record.url);

                          // print(await Directory(
                          //         '/data/user/0/com.example.download_hls_flutter/app_flutter/')
                          //     .delete(recursive: true));

                          await Get.to(VideoPlayerPage(loc));
                        },
                        contentPadding: const EdgeInsets.all(
                          NavigationToolbar.kMiddleSpacing,
                        ),
                        title: Text(getFilePath(record.url)),
                        isThreeLine: true,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: NavigationToolbar.kMiddleSpacing / 2),
                            Text(stripFilePath(record.url)),
                            SizedBox(
                                height: NavigationToolbar.kMiddleSpacing / 2),
                            (record.downloaded < 100)
                                ? Text(
                                    'Downloading...${record.downloaded.toStringAsFixed(1)}%',
                                    style: GoogleFonts.ubuntuMono(
                                      color: Colors.indigoAccent,
                                    ),
                                  )
                                : Text(
                                    'Downloaded',
                                    style: GoogleFonts.ubuntuMono(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                          ],
                        ),
                        trailing: Visibility(
                          visible: record.downloaded >= 100,
                          child: ActionButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              final loc = await findFileLocation(record.url);
                              await Directory(normalizeUrl(loc))
                                  .delete(recursive: true);

                              print('DELETED.');
                              await db.deleteRecord(record);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await Get.toNamed('/download');
            },
            label: Text(
              'NEW',
              style: GoogleFonts.ubuntuMono(
                fontWeight: TypeWeight.bold,
                fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
              ),
            ),
            icon: Icon(
              Icons.file_download,
              size: Theme.of(context).textTheme.headline6.fontSize,
            ),
          ),
        );
      },
    );
  }
}
