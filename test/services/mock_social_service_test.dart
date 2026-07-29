import 'package:flutter_test/flutter_test.dart';
import 'package:badminton_ai_app/models/feed_item.dart';
import 'package:badminton_ai_app/services/mock_social_service.dart';

void main() {
  group('MockSocialService Unit Tests -', () {
    late MockSocialService socialService;

    setUp(() {
      socialService = MockSocialService();
    });

    test('getFeed should return a mixed list of 3 feed items', () async {
      // Act
      final feed = await socialService.getFeed();

      // Assert
      expect(feed.length, 3);
    });

    test(
      'Feed should contain a StatusUpdate, a FlashSale, and a MatchInvite',
      () async {
        // Act
        final feed = await socialService.getFeed();

        // Assert
        // We check that our feed contains one of each specific type
        expect(feed[0].type, FeedItemType.statusUpdate);
        expect(feed[1].type, FeedItemType.flashSale);
        expect(feed[2].type, FeedItemType.matchInvite);
      },
    );

    test(
      'Flash Sale item should contain valid extraData for pricing',
      () async {
        // Act
        final feed = await socialService.getFeed();
        final flashSaleItem = feed.firstWhere(
          (item) => item.type == FeedItemType.flashSale,
        );

        // Assert
        expect(
          flashSaleItem.extraData,
          isNotNull,
          reason: 'Flash sales require extraData payload.',
        );
        expect(flashSaleItem.extraData['discountPrice'], '\$7.50');
        expect(flashSaleItem.extraData['originalPrice'], '\$15');
      },
    );
  });
}
