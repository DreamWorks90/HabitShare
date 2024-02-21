import 'dart:convert';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';

Future<void> main() async {
  final server = await HttpServer.bind('localhost', 3000);
  print('Server listening on ${server.address}:${server.port}');

  final db = await Db('mongodb://localhost:27017/my_database');
  await db.open();

  server.listen((HttpRequest request) async {
    try {
      if (request.method == 'POST' && request.uri.path == '/signup') {
        await handleSignUp(request, db);
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..write('Not Found');
      }
    } catch (e) {
      print('Error: $e');
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Internal Server Error');
    } finally {
      await request.response.close();
    }
  });
}

Future<void> handleSignUp(HttpRequest request, Db db) async {
  final content = await utf8.decoder.bind(request).join();
  final Map<String, dynamic> data = jsonDecode(content);

  final name = data['name'];
  final email = data['email'];
  final password = data['password'];

  final collection = db.collection('users');
  await collection.insert({'name': name, 'email': email, 'password': password});

  request.response
    ..statusCode = HttpStatus.ok
    ..write('Signup successful');
}
