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

// Returns a human-readable days remaining label
String membershipExpiryLabel(DateTime? expiresAt) {
  if (expiresAt == null) return '';

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final expiry = DateTime(expiresAt.year, expiresAt.month, expiresAt.day);

  final difference = expiry.difference(today).inDays;

  if (difference < 0) return 'Expired';
  if (difference == 0) return 'Expiring today';
  if (difference == 1) return '1 day remaining';
  return '$difference days remaining';
}
// Only show label when expiring soon OR already expired
String? getMembershipExpiryWarning(DateTime? expiresAt) {
  if (expiresAt == null) return null;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final expiry = DateTime(expiresAt.year, expiresAt.month, expiresAt.day);
  final difference = expiry.difference(today).inDays;

  // Only return a value when expiring within 5 days or already expired
  if (difference > 5) return null;

  return membershipExpiryLabel(expiresAt);
}



// final warning = getMembershipExpiryWarning(widget.membership.expiresAt);

// if (warning != null)
//   Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//     decoration: BoxDecoration(
//       color: warning == 'Expired'
//           ? Colors.red.withAlpha(30)
//           : Colors.orange.withAlpha(30),
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Text(
//       warning, // "5 days remaining" / "1 day remaining" / "Expiring today" / "Expired"
//       style: AppDefaults.textStyle(context).copyWith(
//         color: warning == 'Expired' ? Colors.red : Colors.orange,
//         fontWeight: FontWeight.w600,
//         fontSize: 12,
//       ),
//     ),
//   ),