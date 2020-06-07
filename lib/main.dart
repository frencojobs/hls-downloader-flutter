import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hlsd/database/database.dart';

import 'pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(Mainframe());
}

class Mainframe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AppDatabase(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HLS Downloader',
        theme: ThemeData(
          fontFamily: GoogleFonts.ubuntuMono().fontFamily,
          primaryColor: Colors.indigo,
          accentColor: Colors.indigoAccent,
          splashFactory: InkRipple.splashFactory,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => DownloadsPage(),
          '/download': (_) => DownloadPage(),
        },
      ),
    );
  }
}
