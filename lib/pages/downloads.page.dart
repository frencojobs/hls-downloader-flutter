import 'dart:io';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:typeweight/typeweight.dart';
import 'package:hlsd/helpers/helpers.dart';
import 'package:hlsd/pages/pages.dart';

class DownloadsPage extends StatefulWidget {
  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  Box<String> downloads;

  @override
  void initState() {
    super.initState();
    downloads = Hive.box('downloads');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Downloads',
          style: GoogleFonts.workSans(
            fontWeight: TypeWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Download New File',
            icon: Icon(Icons.add),
            onPressed: () async {
              // await for (var dir in (await getApplicationDocumentsDirectory())
              //     .list(recursive: true)) {
              //   print(dir.absolute.path);
              // }
              await Get.toNamed('/download');
            },
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: downloads.listenable(),
        builder: (ctx, Box<String> dls, _) {
          if (dls.isEmpty) {
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
          }

          return ListView.builder(
            itemCount: dls.length,
            itemBuilder: (context, index) {
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
                  onTap: () async {
                    final loc = await findFileLocation(dls.getAt(index));

                    // print('ok lar?');
                    // print(await Directory(
                    //         '/data/user/0/com.example.download_hls_flutter/app_flutter/636054010')
                    //     .delete(recursive: true));

                    await Get.to(VideoPlayerPage(loc));
                  },
                  contentPadding: const EdgeInsets.all(
                    NavigationToolbar.kMiddleSpacing,
                  ),
                  title: Text(dls.getAt(index)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      final loc = await findFileLocation(dls.getAt(index));

                      await Directory(normalizeUrl(loc))
                          .delete(recursive: true);

                      print('DELETED.');

                      await dls.deleteAt(index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
