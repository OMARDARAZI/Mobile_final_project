import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../scaned_profile/view.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        setState(() {
          result = scanData;
        });
        Get.off(() => ScanedProfilePage(
              id: scanData.code.toString(),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Scan Here'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            overlay: QrScannerOverlayShape(
              borderColor: Theme.of(context).primaryColor,
              borderRadius: 20,
              borderLength: 70,
              borderWidth: 10,
            ),
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Positioned(
            top: 10,
            right: 20,
            child: IconButton(
                onPressed: () {
                  controller!.toggleFlash();
                  print(controller!.getFlashStatus());
                },
                icon: const Icon(
                  Icons.flash_on,
                  color: Colors.white,
                )),
          ),
          Positioned(
            top: 10,
            left: 20,
            child: IconButton(
                onPressed: () {
                  controller!.flipCamera();
                },
                icon: const Icon(
                  Icons.cameraswitch,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
