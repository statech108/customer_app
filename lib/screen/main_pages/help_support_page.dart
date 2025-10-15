import 'package:flutter/material.dart';

class HelpSupportPage extends StatefulWidget {
  @override
  _HelpSupportPageState createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'How do I update my profile information?',
      'answer': 'You can update your profile by navigating to "My Profile" > "Edit Profile" and making changes there. All changes are saved automatically.',
    },
    {
      'question': 'How can I add a new payment method?',
      'answer': 'Go to "My Profile" > "Payment Methods" and tap on "Add Payment Method". You can add credit cards, UPI, bank accounts, or enable cash on delivery.',
    },
    {
      'question': 'What should I do if my order is delayed?',
      'answer': 'Please check your "Order History" for status updates. If it\'s still delayed, contact our support team through the "Contact Us" option below.',
    },
    {
      'question': 'How do I track my order?',
      'answer': 'You can track your order by going to "Order History" and selecting the specific order. You\'ll see real-time updates on your order status.',
    },
    {
      'question': 'Can I cancel my order?',
      'answer': 'Yes, you can cancel orders that are still pending. Go to "Order History", find your pending order, and tap "Cancel".',
    },
    {
      'question': 'How do I add items to favorites?',
      'answer': 'While browsing products, tap the heart icon to add items to your favorites. You can view all favorites in "My Profile" > "Favorites".',
    },
    {
      'question': 'What payment methods do you accept?',
      'answer': 'We accept credit/debit cards, UPI, bank transfers, and cash on delivery. You can manage your payment methods in your profile.',
    },
    {
      'question': 'How do I contact customer support?',
      'answer': 'You can contact us via email, phone, or live chat using the contact options below. Our support team is available 24/7.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Help & Support", style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(context),
            const SizedBox(height: 30),
            _buildFaqSection(context),
            const SizedBox(height: 30),
            _buildContactSection(context),
            const SizedBox(height: 30),
            _buildQuickActionsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.withOpacity(0.1), Colors.teal.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.help_outline,
            size: 48,
            color: Colors.teal,
          ),
          const SizedBox(height: 16),
          Text(
            "How can we help you?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Find answers to common questions or get in touch with our support team.",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Frequently Asked Questions",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ..._faqItems.map<Widget>((Map<String, dynamic> faq) => _buildFaqItem(context, faq['question'], faq['answer'])).toList(),
      ],
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Contact Us",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactOption(
          context,
          Icons.email_outlined,
          "Email Support",
          "support@example.com",
          "Get help via email",
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Opening email client...")),
            );
          },
        ),
        _buildContactOption(
          context,
          Icons.phone_outlined,
          "Call Us",
          "+91 12345 67890",
          "Speak with our support team",
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Initiating call...")),
            );
          },
        ),
        _buildContactOption(
          context,
          Icons.chat_outlined,
          "Live Chat",
          "Chat with a representative",
          "Get instant help",
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Starting live chat...")),
            );
          },
        ),
        _buildContactOption(
          context,
          Icons.schedule_outlined,
          "Support Hours",
          "24/7 Available",
          "We're here to help anytime",
          () {},
        ),
      ],
    );
  }

  Widget _buildContactOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String description,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.teal, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              subtitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildQuickActionCard(
                context,
                Icons.bug_report_outlined,
                "Report a Bug",
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Opening bug report form...")),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                Icons.lightbulb_outline,
                "Suggest Feature",
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Opening feature request form...")),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildQuickActionCard(
                context,
                Icons.rate_review_outlined,
                "Rate App",
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Opening app store...")),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                Icons.share_outlined,
                "Share App",
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sharing app...")),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, color: Colors.teal, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
