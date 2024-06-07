import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
    final String phoneNumber;

  const VerificationPage({super.key, required this.phoneNumber});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
    final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.10),
          child: Column(
            children: [
              Text(
                'Verify OTP!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: width * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.01),
              RichText(
                text: TextSpan(
                  text: 'Enter the OTP sent to ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: width * 0.03,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '+91 9874563210',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.03,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const TextSpan(
                      text: ' ',
                    ),
                    // WidgetSpan(
                    //   child: Icon(
                    //     Icons.edit,
                    //     color: Colors.white,
                    //     size: 16,
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return Container(
                    width: width * 0.17,
                    height: width * 0.17,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: height * 0.1),
              GestureDetector(
                onTap: () {
                  // Resend OTP function
                },
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.03,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
