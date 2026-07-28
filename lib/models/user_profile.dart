class UpcomingBooking {
  final String id;
  final String courtName;
  final String date;
  final String time;
  final double amountPaid;

  UpcomingBooking({
    required this.id,
    required this.courtName,
    required this.date,
    required this.time,
    required this.amountPaid,
  });
}

class UserProfile {
  final String name;
  final String skillLevel;
  final String profileImageUrl;
  final double walletBalance;
  final List<UpcomingBooking> upcomingBookings;

  UserProfile({
    required this.name,
    required this.skillLevel,
    required this.profileImageUrl,
    required this.walletBalance,
    required this.upcomingBookings,
  });
}
