import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/email_verification_provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  EmailVerificationScreen({required this.email});

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    codeController.addListener(() {
      final provider = context.read<EmailVerificationProvider>();
      provider.updateCodeValid(codeController.text.length == 6);
    });
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailVerificationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: 12,
                      left: 0,
                      child: Container(
                        width: 56,
                        height: 8,
                        color: Color(0xFF58C4B6),
                      ),
                    ),
                    Text(
                      "Sign up to Xplora",
                      style: TextStyle(
                        fontFamily: 'Fira Sans Condensed',
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Color(0xFF121414),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "We are almost finished.",
                  style: TextStyle(
                    fontFamily: 'Fira Sans Condensed',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Fira Sans Condensed',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: "We sent a 6-digit confirmation code to "),
                      TextSpan(
                        text: widget.email,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text:
                          ". If you haven’t received it yet, check Spam or press 'Resend'."),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      "Send the code again ",
                      style: TextStyle(
                        fontSize: 14,
                        color: provider.resendCooldown > 0 ? Colors.grey : Colors.black,
                      ),
                    ),
                    provider.resendCooldown > 0
                        ? Text(
                      "in ${provider.resendCooldown} sec",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                        : GestureDetector(
                      onTap: () => provider.resendCode(widget.email, context),
                      child: Text(
                        "Resend now",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8AC0C7),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Confirmation code",
                    labelStyle: TextStyle(fontSize: 16, color: Color(0xFF8AC0C7)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF8AC0C7), width: 2.0),
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: provider.isCodeValid
                      ? () => provider.verifyEmail(widget.email, codeController.text, context)
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      return provider.isCodeValid ? Color(0xFF8AC0C7) : Color(0xFFF0F0F0);
                    }),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    ),
                    fixedSize: MaterialStateProperty.all(Size(327, 48)),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  child: provider.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Confirm",
                    style: TextStyle(
                      fontFamily: 'Fira Sans Condensed',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: provider.isCodeValid ? Colors.white : Color(0xFF797C7B),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
