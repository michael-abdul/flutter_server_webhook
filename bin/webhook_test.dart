import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {

  Map<String, dynamic>? payload;
  final router = Router();

 
  Future<Response> handleWebhook(Request request) async {
    if (request.method == 'POST') {
      final body = await request.readAsString();
      payload = jsonDecode(body);

      print('Webhook received: $payload');

      return Response.ok(
        jsonEncode({'status': 'success', 'data': payload}),
        headers: {'Content-Type': 'application/json'},
      );
    }
    return Response.notFound('Not Found');
  }

  
  Response getWebhookPayload(Request request) {
    if (payload == null) {
      return Response.ok(
        jsonEncode({'message': 'No webhook data received yet'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
    return Response.ok(
      jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );
  }


  router.post('/webhook', handleWebhook);
  router.get('/webhook', getWebhookPayload);

  // Routerni Pipeline bilan ulash
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router);

  // Serverni ishga tushirish
  final server = await serve(handler, InternetAddress.anyIPv4, 8080);
  print('Server started on http://${server.address.host}:${server.port}');
}
