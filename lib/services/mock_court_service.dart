import '../models/court.dart';

class MockCourtService {
  // Simulates an API call to get nearby courts
  Future<List<Court>> fetchNearbyCourts() async {
    await Future.delayed(
      const Duration(milliseconds: 1500),
    ); // Fake network delay

    return [
      Court(
        id: '1',
        name: 'Jaffna Smashers',
        surfaceType: 'Wood',
        pricePerHour: 10.0,
        distanceKm: 2.1,
      ),
      Court(
        id: '2',
        name: 'Nallur Shuttlers',
        surfaceType: 'Synthetic Mat',
        pricePerHour: 12.0,
        distanceKm: 3.5,
      ),
      Court(
        id: '3',
        name: 'City Center Courts',
        surfaceType: 'Concrete',
        pricePerHour: 8.0,
        distanceKm: 5.0,
      ),
    ];
  }
}
