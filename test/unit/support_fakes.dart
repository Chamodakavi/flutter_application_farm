import 'package:farmfriend/features/profile/domain/app_user.dart';
import 'package:farmfriend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:farmfriend/features/support/data/complaint_repository.dart';
import 'package:farmfriend/features/support/domain/complaint.dart';

/// In-memory `complaints` table for one user.
class FakeComplaintRepository implements ComplaintRepository {
  FakeComplaintRepository([List<Complaint> initial = const []]) : rows = List.of(initial);

  List<Complaint> rows;
  Object? fetchError;
  Object? sendError;
  Object? markReadError;
  int fetches = 0;
  final sent = <Map<String, String?>>[];
  final markedRead = <int>[];
  List<Complaint>? cached;

  @override
  Future<List<Complaint>> fetchMine() async {
    fetches++;
    if (fetchError != null) throw fetchError!;
    return List.of(rows);
  }

  @override
  Future<Complaint> fetchById(int id) async {
    if (fetchError != null) throw fetchError!;
    return rows.firstWhere((c) => c.id == id);
  }

  @override
  Future<Complaint> send({
    required String subject,
    required String body,
    String? userName,
    String? userEmail,
  }) async {
    if (sendError != null) throw sendError!;
    sent.add({'subject': subject, 'body': body, 'user_name': userName, 'user_email': userEmail});
    final created = Complaint(
      id: 100 + sent.length,
      subject: subject,
      body: body,
      status: 'Pending',
      createdAt: DateTime(2026, 10, 5, 9),
    );
    rows = [created, ...rows];
    return created;
  }

  @override
  Future<void> markRead(int id) async {
    if (markReadError != null) throw markReadError!;
    markedRead.add(id);
  }

  @override
  Future<void> saveToCache(List<Complaint> complaints) async => cached = List.of(complaints);
}

/// A loaded profile without touching Supabase.
class FakeProfileController extends ProfileController {
  FakeProfileController(this.user);

  final AppUser? user;

  @override
  Future<AppUser?> build() async => user;
}
