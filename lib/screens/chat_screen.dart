import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/mock_ai_agent.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final MockAIAgent _aiAgent = MockAIAgent();

  // Initial chat history
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hi! I'm your AI Assistant. How can I help you today?",
      isUser: false,
    ),
  ];

  bool _isTyping = false; // Controls the loading indicator

  void _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final userText = _textController.text.trim();
    _textController.clear();

    // 1. Add User Message to UI
    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true));
      _isTyping = true; // Show "AI is typing..."
    });

    // 2. Call the Mock AI Agent
    final aiResponse = await _aiAgent.processPrompt(userText);

    // 3. Add AI Response to UI
    setState(() {
      _isTyping = false;
      _messages.add(aiResponse);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'AI Court Assistant',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Chat History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // "Typing" indicator
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "AI is thinking...",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

          // Message Input Field
          _buildMessageInput(),
        ],
      ),
    );
  }

  // --- THE MAGIC HAPPENS HERE: Rendering based on MessageType ---
  Widget _buildMessageBubble(ChatMessage message) {
    return Column(
      crossAxisAlignment: message.isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        // Standard Text Bubble
        Container(
          margin: const EdgeInsets.only(bottom: 8, top: 8),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.teal : Colors.white,
            borderRadius: BorderRadius.circular(16).copyWith(
              bottomRight: message.isUser
                  ? const Radius.circular(0)
                  : const Radius.circular(16),
              bottomLeft: !message.isUser
                  ? const Radius.circular(0)
                  : const Radius.circular(16),
            ),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isUser ? Colors.white : Colors.black87,
            ),
          ),
        ),

        // GENERATIVE UI: If the AI sent a widget payload, render it here!
        if (!message.isUser &&
            message.type == MessageType.courtSelector &&
            message.payload != null)
          _buildGenerativeCourtSelector(message.payload),
      ],
    );
  }

  // The dynamically generated UI component
  Widget _buildGenerativeCourtSelector(List<dynamic> courts) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: courts.map((court) {
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.sports_tennis, color: Colors.teal),
              title: Text(
                court['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Time: ${court['time']} • Fee: ${court['price']}"),
              trailing: ElevatedButton(
                onPressed: () {
                  // ScaffoldMessenger shows a snackbar popup
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Booked ${court['name']} at ${court['time']}!',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Select"),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // The bottom input bar
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Type "Book a court"...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.teal,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
