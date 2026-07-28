import '../models/user_profile.dart';

class MockUserService {
  Future<UserProfile> getUserProfile() async {
    await Future.delayed(const Duration(seconds: 1)); // Network simulation

    return UserProfile(
      name: "Dinesh K.",
      skillLevel: "Intermediate / Aggressive",
      profileImageUrl: "D", // Just using initial for Avatar
      walletBalance: 24.50,
      upcomingBookings: [
        UpcomingBooking(
          id: "B101",
          courtName: "Jaffna Smashers (Wood)",
          date: "Today",
          time: "7:00 PM - 8:00 PM",
          amountPaid: 10.00,
        ),
        UpcomingBooking(
          id: "B102",
          courtName: "City Center Courts",
          date: "Saturday, Oct 24",
          time: "9:00 AM - 11:00 AM",
          amountPaid: 16.00,
        ),
      ],
    );
  }
}
