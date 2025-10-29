import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RazorpayWebCheckoutPage extends StatefulWidget {
  final Map<String, dynamic> options;

  const RazorpayWebCheckoutPage({super.key, required this.options});

  @override
  State<RazorpayWebCheckoutPage> createState() => _RazorpayWebCheckoutPageState();
}

class _RazorpayWebCheckoutPageState extends State<RazorpayWebCheckoutPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  String _buildCheckoutHtml(Map<String, dynamic> options) {
    // Escape values for safe embedding
    final esc = const JsonEncoder().convert;

    final key = esc(options['key']);
    final amount = options['amount'];
    final currency = esc(options['currency'] ?? 'INR');
    final name = esc(options['name'] ?? 'Payment');
    final description = esc(options['description'] ?? '');
    final orderId = esc(options['order_id']);
    final color = esc((options['theme']?['color']) ?? '#FF7622');
    final prefillContact = esc(options['prefill']?['contact'] ?? '');
    final prefillEmail = esc(options['prefill']?['email'] ?? '');

    return """
<!doctype html>
<html>
<head>
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no\" />
</head>
<body>
  <script src=\"https://checkout.razorpay.com/v1/checkout.js\"></script>
  <script>
    var options = {
      key: $key,
      amount: $amount,
      currency: $currency,
      name: $name,
      description: $description,
      order_id: $orderId,
      prefill: {
        email: $prefillEmail,
        contact: $prefillContact
      },
      theme: {
        color: $color
      },
      handler: function (response){
        try {
          RZP.postMessage(JSON.stringify({
            event: 'success',
            razorpay_payment_id: response.razorpay_payment_id,
            razorpay_order_id: response.razorpay_order_id,
            razorpay_signature: response.razorpay_signature
          }));
        } catch (e) {
          // ignore
        }
      },
      modal: {
        ondismiss: function () {
          try {
            RZP.postMessage(JSON.stringify({ event: 'dismiss' }));
          } catch (e) {}
        }
      }
    };
    var rzp1 = new Razorpay(options);
    rzp1.on('payment.failed', function (response){
      try {
        RZP.postMessage(JSON.stringify({
          event: 'failure',
          error: response.error || response
        }));
      } catch (e) {}
    });
    window.onload = function() { rzp1.open(); };
  </script>
</body>
</html>
""";
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('RZP', onMessageReceived: (JavaScriptMessage msg) {
        try {
          final data = jsonDecode(msg.message) as Map<String, dynamic>;
          final event = data['event'];
          if (event == 'success') {
            Navigator.of(context).pop({
              'success': true,
              'razorpay_payment_id': data['razorpay_payment_id'],
              'razorpay_order_id': data['razorpay_order_id'],
              'razorpay_signature': data['razorpay_signature'],
            });
          } else if (event == 'failure') {
            Navigator.of(context).pop({ 'success': false, 'error': data['error'] });
          } else if (event == 'dismiss') {
            Navigator.of(context).pop({ 'success': false, 'dismissed': true });
          }
        } catch (e) {
          Navigator.of(context).pop({ 'success': false, 'error': { 'message': e.toString() } });
        }
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) { setState(() { _isLoading = false; }); },
        ),
      )
      ..loadHtmlString(_buildCheckoutHtml(widget.options));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Payment')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
