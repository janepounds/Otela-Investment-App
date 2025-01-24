import 'package:flutter/material.dart';
import 'package:otela_investment_club_app/screens/create_account.dart';
import 'package:otela_investment_club_app/screens/investing.dart';
import 'package:otela_investment_club_app/screens/investing/bank_transfer_screen.dart';
import 'package:otela_investment_club_app/screens/investing/fund_details_screen.dart';
import 'package:otela_investment_club_app/screens/investing/payment_method_screen.dart';
import 'package:otela_investment_club_app/screens/investing/select_amount_screen.dart';
import 'package:otela_investment_club_app/screens/investing/success_screen.dart';
import 'package:otela_investment_club_app/screens/login_screen.dart';
import 'package:otela_investment_club_app/screens/main_screen.dart';
import 'package:otela_investment_club_app/screens/portfolio.dart';
import 'package:otela_investment_club_app/screens/splash_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/login': (context) => LoginScreen(),
      '/createAccount': (context) => CreateAccountScreen(),
      '/main': (context) => MainScreen(),
      '/investing': (context) => InvestingScreen(),
      '/portfolio': (context) => PortfolioScreen(),

      // Investing-related routes
      '/fundDetails': (context) => FundDetailsScreen(),
      '/selectAmount': (context) => SelectAmountScreen(),
      '/paymentMethod': (context) => PaymentMethodScreen(),
      '/bankTransfer': (context) => BankTransferScreen(),
      '/success': (context) => SuccessScreen(),
    },
  ));
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Otela App',
      home: SplashScreen(),
    );
 
  }
}

