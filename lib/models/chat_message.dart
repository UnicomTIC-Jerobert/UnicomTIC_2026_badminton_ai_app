enum MessageType { text, courtSelector }

class ChatMessage {
  final String text;
  final bool isUser; // True if sent by the user, False if sent by AI
  final MessageType type;
  final dynamic payload; // This will hold our "Generative UI" JSON data

  ChatMessage({
    required this.text,
    required this.isUser,
    this.type = MessageType.text,
    this.payload,
  });
}
