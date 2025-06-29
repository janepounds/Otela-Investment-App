import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/bank_details_screen.dart';
import 'package:otela_investment_club_app/screens/create_account.dart';
import 'package:otela_investment_club_app/screens/create_club.dart';
import 'package:otela_investment_club_app/screens/dashboard_screen.dart';
import 'package:otela_investment_club_app/screens/investing.dart';
import 'package:otela_investment_club_app/screens/investing/bank_transfer_screen.dart';
import 'package:otela_investment_club_app/screens/investing/fund_details_screen.dart';
import 'package:otela_investment_club_app/screens/investing/payment_method_screen.dart';
import 'package:otela_investment_club_app/screens/investing/select_amount_screen.dart';
import 'package:otela_investment_club_app/screens/investing/success_screen.dart';
import 'package:otela_investment_club_app/screens/join_club.dart';
import 'package:otela_investment_club_app/screens/login_screen.dart';
import 'package:otela_investment_club_app/screens/main_screen.dart';
import 'package:otela_investment_club_app/screens/my_profile_bank_details_screen.dart';
import 'package:otela_investment_club_app/screens/personal_details_screen.dart';
import 'package:otela_investment_club_app/screens/personal_kyc_screen.dart';
import 'package:otela_investment_club_app/screens/portifolio_management/portfolio.dart';
import 'package:otela_investment_club_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:otela_investment_club_app/screens/upload_document_screen.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp()); // ✅ Use MyApp here
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Otela App',
      theme: ThemeData(
        fontFamily: 'Poppins',
         textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'poppins', color: Colors.white),
          titleLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,fontFamily: 'poppins', color: Colors.white),
          titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darBlue),
          bodyMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'poppins', color: Colors.white),
          labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'poppins', color: Colors.grey),
          labelSmall: TextStyle(fontSize: 10,  fontWeight: FontWeight.w500, fontFamily: 'poppins', color: Colors.grey),
        )
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/createAccount': (context) => CreateAccountScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/main': (context) => MainScreen(),
        '/investing': (context) => InvestingScreen(),
        '/portfolio': (context) => PortfolioScreen(),
        '/fundDetails': (context) => FundDetailsScreen(),
        '/selectAmount': (context) => SelectAmountScreen(),
        '/paymentMethod': (context) => PaymentMethodScreen(),
        '/bankTransfer': (context) => BankTransferScreen(),
        '/success': (context) => SuccessScreen(),
        '/createStokvel': (context) => CreateStokvelScreen(),
        '/uploadDocuments': (context) => UploadDocumentScreen(),
        '/bankDetails': (context) => BankDetailscreen(),
        '/joinStokvel': (context) => JoinStokvelScreen(),
        '/kyc': (context) => PersonalKycScreen(),
        '/personalDetails': (context) => PersonalDetailsScreen(),
        '/bank': (context) => MyProfileBankDetailScreen(),
      },
    );
  }
}

