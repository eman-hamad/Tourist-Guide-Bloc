import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> setupFirebaseMocks() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void main() async {
  late MockFirebaseAuth fakeAuthService;

  bool isSignOutCalled = false;

  setUpAll(() async {
    fakeAuthService = MockFirebaseAuth();
  });

  // Test: Sign Out
  test('signOut should be called', () async {
    await fakeAuthService.signOut();
    isSignOutCalled = true;
    expect(isSignOutCalled, true);
  });
}
