import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:discoveria/components/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/auth.dart';

class RequestScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userImage;
  final String requestMessage;
  final String requestTime;

  RequestScreen({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.requestMessage,
    required this.requestTime,
  });

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  bool _isLoading = false;

  Future<void> _updateRequestStatus(String status) async {
    setState(() {
      _isLoading = true;
    });

    final url = 'https://xplora.robosoft.kz/api/user-requests/';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AuthConst.tokenKey);
    try {
      final response = await http.put(
        Uri.parse(url),

        headers: {
          'Authorization': 'Bearer $token', // замените на реальный токен
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "user_id": widget.userId,
          "status": status,
        }),
      );
      print(widget.userId);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Запрос успешно обновлён')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при обновлении запроса')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _approve() {
    _updateRequestStatus("approve");
  }

  void _deny() {
    _updateRequestStatus("deny");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Back to requests",
          style: TextStyle(
            fontFamily: 'Fira Sans Condensed',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userImage),
                  radius: 28,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: TextStyle(
                        fontFamily: 'Fira Sans Condensed',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.requestTime,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Message to you",
              style: TextStyle(
                fontFamily: 'Fira Sans Condensed',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF77C2C8),
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.requestMessage,
              style: TextStyle(
                fontFamily: 'Fira Sans Condensed',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _deny,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Deny",
                      style: TextStyle(
                        fontFamily: 'Fira Sans Condensed',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _approve,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF77C2C8),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Approve",
                      style: TextStyle(
                        fontFamily: 'Fira Sans Condensed',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
    );
  }
}
