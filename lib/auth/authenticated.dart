// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gymklout/app-models/user_model.dart';

// final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
//   return FirebaseAuth.instance;
// });

// final authStateProvider = StreamProvider<AppUser?>((ref) {
//   return FirebaseAuth.instance.authStateChanges().asyncExpand((firebaseUser) {
//     if (firebaseUser == null) return Stream.value(null);

//     final userRef = FirebaseFirestore.instance
//         .collection('customers')
//         .doc(firebaseUser.uid);

//     return userRef.snapshots().map((doc) {
//       try {
//         final data = doc.data();
//         if (data == null) return _fallbackUser(firebaseUser);

//         return AppUser.fromMap({
//           ...data,
//           'uid': firebaseUser.uid,
//           'email': data['email'] ?? firebaseUser.email,
//         });
//       } catch (e, st) {
//         debugPrint('authStateProvider error: $e\n$st');
//         return _fallbackUser(firebaseUser);
//       }
//     });
//   });
// });

// AppUser _fallbackUser(User firebaseUser) {
//   return AppUser(
//     uid: firebaseUser.uid,
//     email: firebaseUser.email,
//     fullname: '',
//     phone: '',
//     emailVerified: false,
//     addresses: [],
//     createdAt: null,
//   );
// }

// // Convenience provider — use this in UI instead of authStateProvider directly
// final currentUserProvider = Provider<AppUser?>((ref) {
//   return ref.watch(authStateProvider).asData?.value;
// });

// // Quick auth check
// final isAuthenticatedProvider = Provider<bool>((ref) {
//   return ref.watch(currentUserProvider) != null;
// });

// // Theme provider
