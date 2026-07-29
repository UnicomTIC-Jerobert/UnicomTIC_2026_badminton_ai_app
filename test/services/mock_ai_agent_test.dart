import 'package:flutter_test/flutter_test.dart';
// Note: Replace 'badminton_ai_app' with your actual project name from pubspec.yaml
import 'package:badminton_ai_app/models/chat_message.dart';
import 'package:badminton_ai_app/services/mock_ai_agent.dart';

void main() {
  // 'group' allows us to organize related tests together
  group('MockAIAgent Unit Tests -', () {
    late MockAIAgent aiAgent;

    // setUp() runs exactly once BEFORE every single test.
    // This is the "Arrange" phase for the whole group.
    setUp(() {
      aiAgent = MockAIAgent();
    });

    test(
      'Should return Generative UI (courtSelector) when prompt contains "book"',
      () async {
        // 1. Arrange
        const userPrompt = "I want to book a wooden court";

        // 2. Act
        final response = await aiAgent.processPrompt(userPrompt);

        // 3. Assert
        expect(
          response.isUser,
          false,
          reason: 'The response should come from the AI, not the user.',
        );
        expect(
          response.type,
          MessageType.courtSelector,
          reason: 'It should trigger the UI widget type.',
        );
        expect(
          response.payload,
          isNotNull,
          reason: 'The payload JSON should not be null.',
        );
        expect(
          (response.payload as List).length,
          2,
          reason: 'It should return exactly 2 mock courts.',
        );
      },
    );

    test(
      'Should return standard Text response when prompt is a general greeting',
      () async {
        // 1. Arrange
        const userPrompt = "Hello, who are you?";

        // 2. Act
        final response = await aiAgent.processPrompt(userPrompt);

        // 3. Assert
        expect(response.isUser, false);
        expect(
          response.type,
          MessageType.text,
          reason: 'It should default to a text response.',
        );
        expect(
          response.payload,
          isNull,
          reason: 'Text responses should not have a UI payload.',
        );
      },
    );
  });
}
