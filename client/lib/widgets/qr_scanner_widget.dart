import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerWidget extends StatefulWidget {
  final ValueChanged<String> onCode;

  const QRScannerWidget({super.key, required this.onCode});

  @override
  State<QRScannerWidget> createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'WBISQR');
  QRViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: _qrKey,
      onQRViewCreated: (controller) {
        _controller = controller;
        controller.scannedDataStream.listen((scan) {
          final code = scan.code;
          if (code != null && code.isNotEmpty) {
            widget.onCode(code);
          }
        });
      },
      overlay: QrScannerOverlayShape(
        borderRadius: 12,
        borderWidth: 8,
        cutOutSize: MediaQuery.of(context).size.width * 0.72,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
