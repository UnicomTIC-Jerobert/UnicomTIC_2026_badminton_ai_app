import 'package:flutter_test/flutter_test.dart';
// Note: change 'badminton_ai_app' to your actual project name if different
import 'package:badminton_ai_app/models/court.dart';
import 'package:badminton_ai_app/services/mock_court_service.dart';

void main() {
  group('MockCourtService Unit Tests -', () {
    late MockCourtService courtService;

    setUp(() {
      courtService = MockCourtService();
    });

    test(
      'fetchNearbyCourts should return a list of exactly 3 courts',
      () async {
        // Act
        final courts = await courtService.fetchNearbyCourts();

        // Assert
        expect(
          courts,
          isA<List<Court>>(),
          reason: 'Should return a List of Court objects.',
        );
        expect(courts.length, 3, reason: 'We expect exactly 3 mock courts.');
      },
    );

    test('First court should be Jaffna Smashers and be Wood surface', () async {
      // Act
      final courts = await courtService.fetchNearbyCourts();
      final firstCourt = courts.first;

      // Assert
      expect(firstCourt.name, 'Jaffna Smashers');
      expect(firstCourt.surfaceType, 'Wood');
      expect(firstCourt.pricePerHour, 10.0);
      expect(
        firstCourt.distanceKm,
        greaterThan(0),
        reason: 'Distance must be a positive number.',
      );
    });
  });
}
