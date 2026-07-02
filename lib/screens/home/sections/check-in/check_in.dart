// class CheckInScreen extends ConsumerStatefulWidget {
//   const CheckInScreen({super.key});

//   @override
//   ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
// }

// class _CheckInScreenState extends ConsumerState<CheckInScreen> {
//   bool _isProcessing = false;

//   Future<void> _handleScannedGymId(String gymId) async {
//     if (_isProcessing) return; // prevent double-fires from rapid scan callbacks
//     setState(() => _isProcessing = true);

//     try {
//       final alreadyCheckedIn =
//           await ref.read(visitsProvider.notifier).checkIn(gymId);

//       if (!mounted) return;

//       if (alreadyCheckedIn) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("You've already checked in today ✅")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Checked in! 🎉')),
//         );
//       }

//       Navigator.of(context).pop(); // back to home after successful scan
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Check-in failed: $e')),
//       );
//     } finally {
//       if (mounted) setState(() => _isProcessing = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Actual MobileScanner widget wiring goes here once you build the scanner UI —
//     // its onDetect callback is where you'd call _handleScannedGymId(decodedGymId).
//     return Scaffold(
//       appBar: AppBar(title: const Text('Scan to Check In')),
//       body: _isProcessing
//           ? const Center(child: CircularProgressIndicator())
//           : const Center(child: Text('Camera preview goes here')),
//     );
//   }
// }