import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حول التطبيق')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تم إنشاء هذا المشروع بواسطة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'ABDULLAH ALASAAD & ARX-Tech',
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
            const SizedBox(height: 40),
            const Text(
              'روابط التواصل:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _launchURL('https://www.facebook.com/profile.php?id=61579097697055'),
              icon: const Icon(Icons.facebook),
              label: const Text('تابعنا على فيسبوك'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _launchURL('https://t.me/mar01abdullah'),
              icon: const Icon(Icons.telegram),
              label: const Text('تواصل مع الدعم'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
            const Spacer(),
            const Center(
              child: Text(
                '© جامعتي - جميع الحقوق محفوظة',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}