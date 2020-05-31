import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  const downloads = 'downloads';

  await Hive.initFlutter();
  await Hive.openBox<String>(downloads);

  runApp(Mainframe());
}

class Mainframe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HLS Downloader',
      theme: ThemeData(
        fontFamily: GoogleFonts.workSans().fontFamily,
        primaryColor: Colors.black,
        splashFactory: InkRipple.splashFactory,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => DownloadsPage(),
        '/download': (_) => DownloadPage(),
      },
    );
  }
}
