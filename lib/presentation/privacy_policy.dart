import 'package:flutter/material.dart';

import '../style/styling.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: Styling.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrivacyPolicySection(
              title: '1. Introduction:',
              content: [
                'Welcome to E-MECH!',
                'This Privacy Policy outlines how we collect, use, and protect your personal information when you use our mobile application.',
              ],
            ),
            PrivacyPolicySection(
              title: '2. Information We Collect:',
              content: [
                'User Profile Information: We may collect and store information you provide when creating a user or seller profile. This may include your name, email address, contact information, and profile picture.',
                'Location Data: We may access your device\'s GPS or other location services to provide location-based features, such as finding nearby sellers or users.',
                'Usage Data: We may collect information about how you interact with our app, including the features you use and the actions you take.',
              ],
            ),
            PrivacyPolicySection(
              title: '3. How We Use Your Information:',
              content: [
                'Providing Services: We use your information to provide the services you request, such as connecting users with sellers for emergency assistance.',
                'Communication: We may send you service-related notifications and updates.',
              ],
            ),
            PrivacyPolicySection(
              title: '4. Data Security:',
              content: [
                'We take appropriate measures to protect your data, including encryption and access controls.',
              ],
            ),
            PrivacyPolicySection(
              title: '5. Third-Party Services:',
              content: [
                'We may use third-party services (e.g., Firebase, Google Maps API) that have their own privacy policies.',
              ],
            ),
            PrivacyPolicySection(
              title: '6. Your Choices:',
              content: [
                'You can update or delete your profile information within the app.',
                'You can opt out of receiving non-essential communications.',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicySection extends StatelessWidget {
  final String title;
  final List<String> content;

  PrivacyPolicySection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content
                  .map((paragraph) => Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(paragraph),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
