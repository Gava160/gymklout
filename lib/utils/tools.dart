import 'package:intl/intl.dart';

String formateDateToText(DateTime date) {
  return DateFormat('d MMMM yyyy').format(date);
}

// Returns true if membership expires within 5 days from now
bool isMembershipExpiringSoon(DateTime? expiresAt) {
  if (expiresAt == null) return false;
  final now = DateTime.now();
  final difference = expiresAt.difference(now).inDays;
  return difference >= 0 && difference <= 5;
}