import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    required this.url,
    required this.title,
    super.key,
  });
  final String url;
  final String title;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  var _loadingPercentage = 0;
  var _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // WebViewControllerの初期化
    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _loadingPercentage = 0;
              _hasError = false;
              _errorMessage = null;
            });
          },
          onProgress: (progress) {
            setState(() {
              _loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _loadingPercentage = 100;
            });
          },
          onWebResourceError: (error) {
            setState(() {
              _hasError = true;
              _errorMessage = error.description;
            });
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_loadingPercentage < 100 && !_hasError)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: _loadingPercentage / 100.0,
                ),
              ),
            ),
        ],
      ),
      body: _hasError
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ページの読み込みに失敗しました',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _errorMessage = null;
                          _loadingPercentage = 0;
                        });
                        _controller.reload();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('再読み込み'),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_loadingPercentage < 100)
                  LinearProgressIndicator(
                    value: _loadingPercentage / 100.0,
                  ),
              ],
            ),
    );
  }
}
