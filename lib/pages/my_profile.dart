import 'package:flutter/material.dart';
import 'package:checkmate/models/app_bar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Page Front End - Everything down here is unnecessary
      appBar: appBar(context, "My Profile"),
      body: __body(),
    );
  }

  Column __body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        __nameLogo(),
        const SizedBox(height: 10),
        const Divider(),
        __email(),
        const Divider(),
        __insightsSection(),
      ],
    );
  }

  Padding __insightsSection() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Insights",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _InsightCard(label: "Pending Tasks", value: "0"),
                _InsightCard(label: "Overdue Tasks", value: "0"),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _InsightCard(label: "Current Streak", value: "0"),
                _InsightCard(label: "Longest Streak", value: "0"),
              ],
            ),
          ],
        ),
      );
  }

  Padding __email() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ُEmail Address",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text(
            "email@example.com",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Container __nameLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.amber,
      height: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Name",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                Text(
                  "00 XP",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
          Container(
              // Outline
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color.fromARGB(209, 77, 48, 243), width: 3)),
              padding: const EdgeInsets.all(1.5),
              child: ClipOval(
                child: Image.asset(
                  'assets/app_icon.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              )),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String label;
  final String value;

  const _InsightCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5), //
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: const Color.fromARGB(150, 157, 157, 157),
                blurRadius: 5,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
