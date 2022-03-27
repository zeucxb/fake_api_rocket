import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'models/user.dart';

part 'service.g.dart';

class Service {
  final users = <String, User>{};

  String _generateKey(String seed) => base64Encode(utf8.encode(seed));

  @Route.post('/register')
  Future<Response> _register(Request request) async {
    final params = jsonDecode(await request.readAsString());

    final newUser = User(
      email: params['email'],
      password: params['password'],
      name: params['name'],
    );

    final key = _generateKey(newUser.toString());

    if (users.containsKey(key)) {
      return Response.forbidden('User already exists');
    }

    users[key] = newUser;

    return Response.ok(key);
  }

  @Route.post('/login')
  Future<Response> _login(Request request) async {
    final params = jsonDecode(await request.readAsString());
    final email = params['email'];
    final password = params['password'];
    final key = _generateKey(email);
    final user = users[key];

    if (user != null && user.password == password) {
      return Response.ok(key);
    }

    return Response.forbidden('Invalid login');
  }

  @Route.get('/me')
  Future<Response> _me(Request request) async {
    final key = request.headers['Authorization'];
    final user = users[key];

    if (user != null) {
      return Response.ok(
        user.toJson(),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }

    return Response.forbidden('Invalid token');
  }

  // Default route
  @Route.all('/<ignored|.*>')
  Response _notFound(Request request) => Response.notFound('Page not found');

  Handler get handler => _$ServiceRouter(this);
}
