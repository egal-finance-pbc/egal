import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:conellas/common/deps.dart';


class ScanQr extends StatefulWidget {
  final Dependencies deps;

  ScanQr(this.deps, {Key key}) : super(key: key);

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  ScanResult _scanResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lector de códigos QR'),
      ),
      body: Center(
        child:_scanResult==null?Text('Esperando código a scanear'):Column(
          children: [
            Text('Contenido: ${_scanResult.rawContent}'),
            Text('Formato: ${_scanResult.format.toString()}'),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _scanCode();
        },
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _scanCode() async {
    var result = await BarcodeScanner.scan();
    setState(() {
      _scanResult = result;
    });
  }
}