import 'package:flutter_test/flutter_test.dart';
import 'package:badminton_ai_app/models/user_profile.dart';
import 'package:badminton_ai_app/services/mock_user_service.dart';

void main() {
  group('MockUserService Unit Tests -', () {
    late MockUserService userService;

    setUp(() {
      userService = MockUserService();
    });

    test('getUserProfile should load correct user details', () async {
      // Act
      final user = await userService.getUserProfile();

      // Assert
      expect(user.name, 'Dinesh K.');
      expect(
        user.walletBalance,
        24.50,
        reason: 'Wallet balance should match mock data.',
      );
      expect(
        user.skillLevel,
        contains('Intermediate'),
        reason: 'Skill level should include Intermediate.',
      );
    });

    test('User should have valid upcoming bookings', () async {
      // Act
      final user = await userService.getUserProfile();

      // Assert
      expect(
        user.upcomingBookings,
        isNotEmpty,
        reason: 'User should have at least 1 booking.',
      );
      expect(user.upcomingBookings.length, 2);

      // Let's test the first nested booking
      final firstBooking = user.upcomingBookings.first;
      expect(firstBooking.courtName, 'Jaffna Smashers (Wood)');
      expect(firstBooking.amountPaid, 10.00);
    });
  });
}
