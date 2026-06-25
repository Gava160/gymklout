import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashSecurity({required String pin, required String  salt}) {
  final saltedPin = '$salt$pin';
  final bytes = utf8.encode(saltedPin);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
