import 'package:flutter/material.dart';

// Main Messages List Page
class MessagesListPage extends StatefulWidget {
  @override
  _MessagesListPageState createState() => _MessagesListPageState();
}

class _MessagesListPageState extends State<MessagesListPage> {
  final TextEditingController _searchController = TextEditingController();

  // Sample conversations data
  final List<Map<String, dynamic>> conversations = [
    {
      'id': '1',
      'name': 'Bhabhi Grocery Store',
      'type': 'shop',
      'lastMessage':
          'Your order has been confirmed. We\'ll deliver it in 30 minutes.',
      'time': '2 min ago',
      'unreadCount': 2,
      'isOnline': true,
      'avatar': 'B',
    },
    {
      'id': '2',
      'name': 'Prince Restaurant',
      'type': 'shop',
      'lastMessage': 'Thank you for your order! Food is being prepared.',
      'time': '15 min ago',
      'unreadCount': 0,
      'isOnline': false,
      'avatar': 'P',
    },
    {
      'id': '3',
      'name': 'Rajesh Kumar',
      'type': 'customer',
      'lastMessage': 'Is the shop open today?',
      'time': '1 hour ago',
      'unreadCount': 1,
      'isOnline': true,
      'avatar': 'R',
    },
    {
      'id': '4',
      'name': 'Sneakker Restaurant',
      'type': 'shop',
      'lastMessage': 'We have special offers today. Check them out!',
      'time': '3 hours ago',
      'unreadCount': 0,
      'isOnline': true,
      'avatar': 'S',
    },
    {
      'id': '5',
      'name': 'Priya Sharma',
      'type': 'customer',
      'lastMessage': 'Can you deliver to Model Town?',
      'time': '1 day ago',
      'unreadCount': 0,
      'isOnline': false,
      'avatar': 'P',
    },
  ];

  List<Map<String, dynamic>> filteredConversations = [];

  @override
  void initState() {
    super.initState();
    filteredConversations = conversations;
  }

  void _filterConversations(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredConversations = conversations;
      } else {
        filteredConversations = conversations
            .where(
              (conversation) => conversation['name'].toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterConversations,
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Conversations List
          Expanded(
            child: ListView.builder(
              itemCount: filteredConversations.length,
              itemBuilder: (context, index) {
                final conversation = filteredConversations[index];
                return _buildConversationTile(conversation);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> conversation) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                conversationId: conversation['id'],
                name: conversation['name'],
                type: conversation['type'],
                isOnline: conversation['isOnline'],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      conversation['avatar'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  if (conversation['isOnline'])
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12),

              // Conversation Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          conversation['time'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation['lastMessage'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (conversation['unreadCount'] > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              conversation['unreadCount'].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Individual Chat Page
class ChatPage extends StatefulWidget {
  final String conversationId;
  final String name;
  final String type;
  final bool isOnline;

  const ChatPage({
    Key? key,
    required this.conversationId,
    required this.name,
    required this.type,
    required this.isOnline,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample messages data
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    // Sample messages based on conversation type
    if (widget.type == 'shop') {
      messages = [
        {
          'id': '1',
          'text': 'Hello! Welcome to ${widget.name}. How can I help you today?',
          'isMe': false,
          'time': '10:30 AM',
          'type': 'text',
        },
        {
          'id': '2',
          'text':
              'Hi! I want to order some groceries. Do you have fresh vegetables?',
          'isMe': true,
          'time': '10:32 AM',
          'type': 'text',
        },
        {
          'id': '3',
          'text':
              'Yes, we have fresh vegetables delivered this morning. What would you like to order?',
          'isMe': false,
          'time': '10:33 AM',
          'type': 'text',
        },
        {
          'id': '4',
          'text': 'Can you send me your current menu?',
          'isMe': true,
          'time': '10:35 AM',
          'type': 'text',
        },
        {
          'id': '5',
          'text':
              'Your order has been confirmed. We\'ll deliver it in 30 minutes.',
          'isMe': false,
          'time': '2 min ago',
          'type': 'text',
        },
      ];
    } else {
      messages = [
        {
          'id': '1',
          'text': 'Hi! Is your shop open today?',
          'isMe': false,
          'time': '1 hour ago',
          'type': 'text',
        },
        {
          'id': '2',
          'text': 'Yes, we are open from 8 AM to 10 PM. How can I help you?',
          'isMe': true,
          'time': '58 min ago',
          'type': 'text',
        },
      ];
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': _messageController.text.trim(),
        'isMe': true,
        'time': 'Just now',
        'type': 'text',
      });
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate response after 2 seconds
    if (widget.type == 'shop') {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          messages.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'text':
                'Thank you for your message. We\'ll get back to you shortly.',
            'isMe': false,
            'time': 'Just now',
            'type': 'text',
          });
        });
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: Text(
                widget.name[0],
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.isOnline ? 'Online' : 'Last seen recently',
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isOnline ? Colors.teal : Colors.grey[600],
                      fontWeight: widget.isOnline
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.phone, color: Colors.teal),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Message Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.attach_file, color: Colors.teal),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) => _sendMessage(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: Icon(Icons.send, color: Colors.white),
                    constraints: BoxConstraints(minWidth: 48, minHeight: 48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Text(
                widget.name[0],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? Colors.teal : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    message['time'],
                    style: TextStyle(
                      fontSize: 10,
                      color: isMe ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Text(
                'You'[0],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
