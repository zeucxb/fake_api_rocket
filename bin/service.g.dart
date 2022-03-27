// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ServiceRouter(Service service) {
  final router = Router();
  router.add('POST', r'/register', service._register);
  router.add('POST', r'/login', service._login);
  router.add('GET', r'/me', service._me);
  router.all(r'/<ignored|.*>', service._notFound);
  return router;
}
