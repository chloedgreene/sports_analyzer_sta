import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:lzstring/lzstring.dart';
import 'package:http/http.dart' as http;
import 'package:pastebin/pastebin.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sports_analyzer_sta/data_entry.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'main.dart';

class SendAndShare extends StatefulWidget with GetItStatefulWidgetMixin {
  SendAndShare({super.key});

  @override
  State<SendAndShare> createState() => _SendAndShare();
}

class _SendAndShare extends State<SendAndShare> with GetItStateMixin {
  bool _scanOfflineMode = false;
  //TODO: use compression or setup a pastebin thingy
  void uploadOfflineQr(List<Point> dataPoints) {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    Color chort = Colors.black;
    if (isDarkMode) {
      chort = Colors.white;
    }

    var g = utf8.encode(jsonEncode(dataPoints));
    final gZipJson = gzip.encode(g);
    final base64Json = base64.encode(gZipJson);

    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Scan To Share Data"),
            content: Container(
              width: 500,
              height: 500,
              child: QrImage(
                data: base64Json,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                //size: 200.0,
              ),
            ),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void uploadPastebinQr(List<Point> dataPoints) {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    Color chort = Colors.black;
    if (isDarkMode) {
      chort = Colors.white;
    }

    var g = jsonEncode(dataPoints);

    //prepare pastebin

    var apiEndpoint = 'https://pastebin.com/api/api_post.php';
    var pasteName = 'Point Dump From ${DateTime.now().millisecondsSinceEpoch}';

    http.post(Uri.parse(apiEndpoint), body: {
      'api_option': 'paste',
      'api_dev_key': "A4n5YKo97DBIJqvJDPdr_7PBVA00LU0D",
      'api_paste_code': g,
      'api_paste_name': pasteName,
    }).then((response) {
      if (response.statusCode == 200) {
        showDialog<int>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Scan To Pastebin"),
                content: Container(
                  width: 500,
                  height: 500,
                  child: QrImage(
                    data: response.body,
                    version: QrVersions.auto,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    //size: 200.0,
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to Paste ${response.body}")));
        return;
      }
    });

    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Scan To Pastebin"),
            content: Container(
              width: 500,
              height: 500,
              child: QrImage(
                data: g,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                //size: 200.0,
              ),
            ),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  setState(() {});
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Point> dataPoints = watchOnly((DataPoints gd) => gd.points);

    if (_scanOfflineMode) {
      return Column(
        children: [
          SizedBox(
            width: 500,
            height: 500,
            child: MobileScanner(
              // fit: BoxFit.contain,
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.normal,
                facing: CameraFacing.back,
                torchEnabled: false,
              ),
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                final Uint8List? image = capture.image;
                for (final barcode in barcodes) {
                  print('Barcode found! ${barcode.rawValue}');

                  if ((barcode.rawValue ?? "[]").contains("https")) {
                    var code_blocks = barcode.rawValue!.split('/');
                    var code = code_blocks[code_blocks.length - 1];

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Stat Code: $code}")));

                    var raw_url = "https://pastebin.com/raw/$code";
                    var response =
                      http.get(Uri.parse(raw_url)).then((value) {
                        var DataPointsInstance = GetIt.I.get<DataPoints>();
                      
                       List<dynamic> data_poits_json_list = jsonDecode(value.body);
 
 
                       data_poits_json_list.forEach((var thingt) {
                         DataPointsInstance.points.add(Point.fromJson(thingt));
                       });
     
                       setState(() {
                         _scanOfflineMode = false;
                       });
                      
                      
                      });

                  }

                  final decodeBase64Json =
                      base64.decode(barcode.rawValue ?? "[]");
                  final decodegZipJson = gzip.decode(decodeBase64Json);
                  final originalJson = utf8.decode(decodegZipJson);

                  var DataPointsInstance = GetIt.I.get<DataPoints>();

                  List<dynamic> data_poits_json_list = jsonDecode(originalJson);

                  data_poits_json_list.forEach((var thingt) {
                    DataPointsInstance.points.add(Point.fromJson(thingt));
                  });

                  setState(() {
                    _scanOfflineMode = false;
                  });
                }
              },
            ),
          )
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: const [
            Text(
              "Send and Share Data",
              style: const TextStyle(fontSize: 28),
            ),
            Divider()
          ],
        ),
        TextButton.icon(
          onPressed: () {
            //Upload to qr
            uploadOfflineQr(dataPoints);
            showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                      content: Text(
                          "Offline Transfers are limited to around 50-ish points"),
                    ),
                barrierDismissible: true);
          },
          icon: const Icon(Icons.upload_file),
          label: const Text("(Offline) Generate QR"),
        ),
        TextButton.icon(
          onPressed: () {
            uploadPastebinQr(dataPoints);
          },
          icon: const Icon(Icons.file_present),
          label: const Text("Upload To PasteBin"),
        ),
        // TextButton.icon(
        //   onPressed: () {
        //     showDialog(
        //         context: context,
        //         builder: (_) => const AlertDialog(
        //               content: Text("Import File"),
        //             ),
        //         barrierDismissible: true);
        //   },
        //   icon: const Icon(Icons.import_export),
        //   label: const Text("Import file"),
        // )
        Divider(),
        TextButton.icon(
          //Download to QR
          onPressed: () {
            if (Platform.isAndroid | Platform.isIOS) {
              setState(() {
                _scanOfflineMode = true;
              });
              showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                        content: Text(
                            "Offline Transfers are limited to around 50-ish points"),
                      ),
                  barrierDismissible: true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Does not support Webcam")));
            }
          },
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text("Scan QR code"),
        ),
      ],
    );
  }
}
