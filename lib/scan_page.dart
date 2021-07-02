import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key key}) : super(key: key);

  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');









  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) =>SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            _buildQrView(context),
            Positioned(child: Container(
              padding: EdgeInsets.all(12),
              child: Text(result !=null ? "Successfully!":"Scan barcode!"),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
            ), bottom: 20,)

          ],
        ),
      ));







  Widget _buildQrView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width * 0.65;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {

      bool scanned = false;
      setState(() {
        this.controller = controller;
      });


    controller.scannedDataStream.listen((scanData) {
      if(!scanned){
        scanned=true;
          setState(() {
            result = scanData;
            this.controller.pauseCamera();
            Navigator.pop(context, result);
          });

      }
     /* WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context, result);


      });*/



    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


}
