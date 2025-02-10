import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otela_investment_club_app/colors.dart';

class FinalConfirmationScreen extends StatelessWidget {
  const FinalConfirmationScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.beige,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
            Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/images/logo.svg', height: 30),
                    Icon(Icons.menu, color: Colors.white, size: 30),
                  ],
                )
              ],
            ),
          ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 16.0),
          //     child: Image.asset('assets/images/logo_no_text.png',
          //         width: 50, height: 50),
          //   ),
          // ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 20), // Spacing
            Expanded(
              // Ensures the form expands to take available space
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  // Enables scrolling if content is too much
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center( 
                      child: Text(
                        'Congratulations!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:  AppColors.darBlue,
                        ),
                      )
                     ),
                      SizedBox(height: 15),
                      Center( 
                      child:Text(
                        'Click the button Done below if you confirm the information provided is accurate & complete.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color:  AppColors.darBlue),
                      )
                      ),
                      SizedBox(height: 10),
                      Center( 
                      child:Text(
                        'Otela requires this information to comply with the regulatory “Know Your Client” requirements.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color:  AppColors.darBlue),
                      )
                      ),
                      SizedBox(height: 10),
                      Center( 
                      child:Text(
                        'We may require additional information for approval on some aspects of this registration.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color:  AppColors.darBlue),
                      )
                      ),
                      SizedBox(height: 10),
                      Center( 
                      child:Text(
                        'You will be contacted within 3 working days.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color:  AppColors.darBlue),
                      )
                      ),
                      SizedBox(height: 10),
                      Center( 
                      child:Text(
                        'Your information has been successfully submitted.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: AppColors.darBlue),
                      )
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          //navigate to main
                           Navigator.popUntil(context, ModalRoute.withName('/main'));

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.beige,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Back to Banking Details',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //new footer
                ),
              ),
            ),
          ],
        ));
  }
 
}
