import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';

/// returns downloaded file path from url

Future<String> findFileLocation(String url) async {
  final hash = url.hashCode.toString();
  final filePath = getFilePath(url);
  final appDocDir = await getApplicationDocumentsDirectory();

  // await for (var dir in appDocDir.list(recursive: true)) {
  //   print(dir.absolute.path);
  // }

  final file = File(p.join(appDocDir.path, hash, filePath));

  return file.absolute.path;
}

/// takes a [url] and remove scheme, and last file part
///
/// for example, https://abc.com/a/b/c.m3u8
/// to
/// abc.com/a/b
String normalizeUrl(String url) {
  final uri = Uri.parse(url);
  final dir = p.join(
    uri.host,
    uri.pathSegments.sublist(0, uri.pathSegments.length - 1).join('/'),
  );

  return dir;
}

String stripFilePath(String url) {
  final uri = Uri.parse(url);
  final dir = p.join(
    uri.host,
    uri.pathSegments.sublist(0, uri.pathSegments.length - 1).join('/'),
  );

  return '${uri.scheme}://' + dir;
}

/// takes a [url] and returns last file path
///
/// for example, https://abc.com/a/b/c.m3u8
/// to
/// c.m3u8
String getFilePath(String url) {
  final uri = Uri.parse(url);

  return uri.pathSegments.last;
}

/// takes a file path and returns path that are not file
///
/// for example `a/b/c.m3u8` to `[a, b]`
List<String> pathSegments(String url) {
  final segments = url.split('/');

  return segments.sublist(0, segments.length - 1);
}

/// downloads a file from [url] to [filepath]/[filename]
Future<File> downloadFile(String url, String filepath, String filename) async {
  final client = http.Client();
  final req = await client.get(Uri.parse(url));
  final bytes = req.bodyBytes;
  final file = File('$filepath/$filename');

  for (final f in pathSegments(filename)) {
    final d = Directory(p.join(filepath, f));

    if (!await d.exists()) {
      await d.create();
    }
  }
  await file.writeAsBytes(bytes);
  return file;
}

Future<List<Segment>> getHlsMediaFiles(Uri uri, List<String> lines) async {
  var playList;

  try {
    playList = await HlsPlaylistParser.create().parse(uri, lines);
  } on ParserException catch (e) {
    print('HLS Parsing Error:');
    print(e);
  }

  if (playList is HlsMediaPlaylist) {
    print('MEDIA Playlist');

    return playList.segments;
  } else if (playList is HlsMasterPlaylist) {
    print('MASTER Playlist');

    return [];
  } else {
    return [];
  }
}

/// download file from [url] and returns downloaded file path
Future<String> load(String url, Function(int) progress) async {
  // the url path without file
  // final filedir = normalizeUrl(url);

  // the file path without full url
  final filename = getFilePath(url);

  // the app's directory to store data
  final appDocDir = await getApplicationDocumentsDirectory();

  // directory to download files
  final downloadDir = Directory(p.join(
    appDocDir.path,
    url.hashCode.toString(), // a hash of url
  ));

  if (!await downloadDir.exists()) {
    await downloadDir.create();
  }

  // the full directory + filename path to download
  final filepath = p.join(downloadDir.path, filename);
  var file = File(filepath);
  if (!await file.exists()) {
    file = await downloadFile(url, downloadDir.path, filename);
  }

  final lines = await file.readAsLines();
  final mediaSegments = await getHlsMediaFiles(Uri.parse(file.path), lines);

  final total = mediaSegments.length;
  var currentProgress = 0;

  print(total);

  for (final entry in mediaSegments.asMap().entries) {
    final index = entry.key;
    final seg = entry.value;

    // internet url to download from
    final urlToDownload = p.join(
      pathSegments(url).join('/'),
      seg.url,
    );

    // print('urlToDownload');
    // print(urlToDownload);

    // application's file to download into
    var ff = File(p.join(downloadDir.path, seg.url));

    if (!await ff.exists()) {
      await downloadFile(urlToDownload, downloadDir.path, seg.url);
    }

    if (index != total - 1) {
      // if not last
      currentProgress += ((1 / total) * 100).round();
      await progress(currentProgress);
    } else {
      currentProgress += (100 - currentProgress);
      await progress(currentProgress);
    }
  }

  return file.absolute.path;
}
