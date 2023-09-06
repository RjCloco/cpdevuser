import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notify extends StatefulWidget {
  const Notify({super.key, required String titlez});

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  List<String> notifications = [];
  final List<String> message = [];
  final List<DateTime> time = [];
  final List<String> name = [
    'Hey Raja !',
    'Hey Thiya !',
    'Hey Swetha !',
    'Hey Aishh !',
    'Hey Akshaya',
    'Hey Teja',
  ];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Notification').get();

      final List<String> notificationMessages = [];
      final List<DateTime> notificationTimes = [];

      for (final QueryDocumentSnapshot<Map<String, dynamic>> document
      in querySnapshot.docs) {
        notificationMessages.add(document['message'] as String);
        notificationTimes.add((document['time'] as Timestamp).toDate());
      }
      setState(() {
        message.clear();
        time.clear();
        message.addAll(notificationMessages);
        time.addAll(notificationTimes);

        // Initialize the notifications list based on the number of messages
        notifications = List<String>.generate(message.length, (index) => 'Charge Partners');
      });
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  String formatNotificationTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50.0, left: 10.0, right: 15.0),
        child: Column(
          children: [
            const Row(
              children: [
                SizedBox(
                  child: Text(
                    "All Notifications",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 30.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 5.0),
                  child: Icon(
                    Icons.notifications_active,
                    size: 28.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: message.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0x99E0E0E0),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 0.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                          ),
                                          child: Image.asset(
                                            "assets/flash.png",
                                            height: 15,
                                            width: 15,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, top: 10.0),
                                          child: Text(notifications[index]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      name[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(message[index]),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    formatNotificationTime(time[index]),
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, right: 0.0),
                                    child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(6.0),
                                          child: Image.asset(
                                            "assets/echargers.jpg",
                                            height: 35,
                                            width: 35,
                                          ),
                                        ))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
