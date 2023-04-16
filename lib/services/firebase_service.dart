import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class FirebaseService {
  String? _token;
  String? _userId;
  late final String? databaseUrl;

  FirebaseService() {
    databaseUrl = dotenv.env['FIREBASE_URL'];
  }

  @protected
  String? get token => _token;

  @protected
  String? get userId => _userId;
}
