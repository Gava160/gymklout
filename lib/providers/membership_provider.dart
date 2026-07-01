import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/models/index.dart';
import 'package:gymklout/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kActiveMembershipKey = 'active_membership_id';

// ─── State ────────────────────────────────────────────────────────────────────
// Sealed class — each status is its own type so the UI can exhaustively switch
sealed class ActiveMembershipState {}

// User has no memberships at all
class MembershipNone extends ActiveMembershipState {}

// User has memberships — one is currently "logged in"
class MembershipLoaded extends ActiveMembershipState {
  final MembershipModel current; // the active/selected membership
  final List<MembershipModel> all; // all memberships (for switching)
  final MembershipSessionStatus sessionStatus;

  MembershipLoaded({
    required this.current,
    required this.all,
    required this.sessionStatus,
  });
}

// What we show based on the current membership's state
enum MembershipSessionStatus {
  active, // status == active AND not expired → full access
  expired, // status == active BUT expiresAt is in the past
  inactive, // status == inactive
  pending, // status == pending → awaiting gym approval
}

// ─── Notifier ─────────────────────────────────────────────────────────────────
class ActiveMembershipNotifier extends AsyncNotifier<ActiveMembershipState> {
  @override
  Future<ActiveMembershipState> build() async {
    return _load();
  }

  Future<ActiveMembershipState> _load() async {
    final api = ref.read(apiServiceProvider);

    // Fetch all memberships for the current user
    final response = await api.get('/memberships/my', requiresAuth: true);
    final membershipsJson = response['memberships'] as List<dynamic>? ?? [];

    if (membershipsJson.isEmpty) return MembershipNone();

    final memberships = membershipsJson
        .map((j) => MembershipModel.fromJson(j as Map<String, dynamic>))
        .toList();

    // Restore last selected membership from persistence
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_kActiveMembershipKey);

    // Try to restore saved membership, fall back to first in list
    final current = savedId != null
        ? memberships.firstWhere(
            (m) => m.id == savedId,
            orElse: () => memberships.first,
          )
        : memberships.first;

    return MembershipLoaded(
      current: current,
      all: memberships,
      sessionStatus: _resolveStatus(current),
    );
  }

  // ─── Resolve what to show based on membership state ───────────────────────
  MembershipSessionStatus _resolveStatus(MembershipModel membership) {
    if (membership.status == MembershipStatus.pending) {
      return MembershipSessionStatus.pending;
    }
    if (membership.status == MembershipStatus.inactive) {
      return MembershipSessionStatus.inactive;
    }
    if (membership.isExpired) {
      return MembershipSessionStatus.expired;
    }
    return MembershipSessionStatus.active;
  }

  // ─── Switch gym (log in to another membership) ────────────────────────────
  Future<void> switchMembership(String membershipId) async {
    final current = state.asData?.value;
    if (current is! MembershipLoaded) {
      return;
    }

    final target = current.all.firstWhere(
      (m) => m.id == membershipId,
      orElse: () => current.current,
    );

    // Persist selection
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kActiveMembershipKey, target.id);

    state = AsyncData(
      MembershipLoaded(
        current: target,
        all: current.all,
        sessionStatus: _resolveStatus(target),
      ),
    );
  }

  // ─── Refresh (re-fetch from API) ──────────────────────────────────────────
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  // ─── Clear (on logout) ────────────────────────────────────────────────────
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kActiveMembershipKey);
    state = AsyncData(MembershipNone());
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────
final activeMembershipProvider =
    AsyncNotifierProvider<ActiveMembershipNotifier, ActiveMembershipState>(
      ActiveMembershipNotifier.new,
    );
