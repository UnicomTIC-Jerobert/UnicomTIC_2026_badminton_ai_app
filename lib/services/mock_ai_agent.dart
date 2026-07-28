import '../models/chat_message.dart';

class MockAIAgent {
  Future<ChatMessage> processPrompt(String userText) async {
    // Simulate LLM processing time (latency)
    await Future.delayed(const Duration(seconds: 2));

    final lowerText = userText.toLowerCase();

    // Trigger Generative UI if the user wants to book
    if (lowerText.contains('book') ||
        lowerText.contains('court') ||
        lowerText.contains('play')) {
      return ChatMessage(
        text: "I found a few available courts for you. Which time works best?",
        isUser: false,
        type: MessageType.courtSelector, // TELLS THE UI TO RENDER A WIDGET!
        payload: [
          {
            "id": "1",
            "name": "Jaffna Smashers (Wood)",
            "time": "6:00 PM",
            "price": "\$10",
          },
          {
            "id": "2",
            "name": "Nallur Courts (Mat)",
            "time": "7:00 PM",
            "price": "\$12",
          },
        ],
      );
    }

    // Default text response
    return ChatMessage(
      text:
          "I'm your Badminton AI Assistant. You can ask me to find courts, book a slot, or find a playing partner!",
      isUser: false,
      type: MessageType.text,
    );
  }
}
