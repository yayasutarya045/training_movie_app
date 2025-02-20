import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:movie/ui/constant/color_pallete.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Jika di Web, langsung buka browser
    if (kIsWeb) {
      _openUrlInBrowser(widget.url);
    } else {
      // Inisialisasi WebViewController untuk Android/iOS
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  // Fungsi untuk membuka URL di browser
  Future<void> _openUrlInBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tidak dapat membuka URL")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title, style: TextStyle(color: Colors.white))),
      backgroundColor: ColorPallete.colorPrimary,
      body: kIsWeb
          ? _buildWebViewForWeb(widget.url) // Pesan untuk Web (hanya sebentar)
          : WebViewWidget(
              controller: _controller), // Gunakan WebView untuk Android/iOS
    );
  }

  // Pesan sementara untuk Web, sebelum membuka browser
  Widget _buildWebViewForWeb(String url) {
    return Center(
      child: Text(
        "Membuka browser...",
        style: TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}
