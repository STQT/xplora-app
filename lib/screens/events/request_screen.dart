import 'package:flutter/material.dart';
import 'package:discoveria/components/bottom_nav_bar.dart';


class RequestToJoinEventScreen extends StatefulWidget {
  final String eventName;
  final String eventDate;

  RequestToJoinEventScreen({required this.eventName, required this.eventDate});

  @override
  _RequestToJoinEventScreenState createState() =>
      _RequestToJoinEventScreenState();
}

class _RequestToJoinEventScreenState extends State<RequestToJoinEventScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            // Header
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Fira Sans Condensed',
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: "Send a message to join "),
                  TextSpan(
                    text: widget.eventName,
                    style: TextStyle(color: Color(0xFF77C2C8)),
                  ),
                  TextSpan(text: " on ${widget.eventDate}!"),
                ],
              ),
            ),
            SizedBox(height: 10),

            // User Input Field
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write some text...",
                hintStyle: TextStyle(
                  fontFamily: 'Fira Sans Condensed',
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),

            Spacer(),

            // Send Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    String message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      // Implement sending request logic here
                      print("Request Sent: $message");
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF77C2C8),
                    fixedSize: Size(268, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Send",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Fira Sans Condensed',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
    );
  }
}
