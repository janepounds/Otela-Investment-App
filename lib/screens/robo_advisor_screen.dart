import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otela_investment_club_app/colors.dart';
import 'package:otela_investment_club_app/screens/main_screen.dart';

class RoboAdvisorScreen extends StatefulWidget {
  const RoboAdvisorScreen({super.key});

  @override
  State<RoboAdvisorScreen> createState() => _RoboAdvisorScreenState();
}

class _RoboAdvisorScreenState extends State<RoboAdvisorScreen> {
  int currentPage = 0;
  bool isFinished = false;
  int totalScore = 0;
  Map<int, int> selectedAnswers = {};

  final List<RoboQuestion> roboQuestions = [
    RoboQuestion(
      question: "What is your investment time horizon?",
      options: [
        RoboOption(text: "Less than 1 year", score: 1),
        RoboOption(text: "1 to 3 years", score: 2),
        RoboOption(text: "4 to 6 years", score: 3),
        RoboOption(text: "7 to 10 years", score: 4),
        RoboOption(text: "More than 10 years", score: 5),
      ],
    ),

    RoboQuestion(
      question: "What is the primary goal of your investment?",
      options: [
        RoboOption(text: "Preserving capital", score: 1),
        RoboOption(text: "Generating regular income", score: 2),
        RoboOption(text: "Growing my wealth moderately", score: 3),
        RoboOption(text: "Maximizing long-term growth", score: 4),
        RoboOption(text: "Saving for a specific goal", score: 3),
      ],
    ),

    RoboQuestion(
      question:
          "How much of a loss could you tolerate in a single year without panicking or needing to sell?",
      options: [
        RoboOption(text: "0% (I cannot tolerate any losses)", score: 1),
        RoboOption(text: "Up to 5%", score: 2),
        RoboOption(text: "Up to 10%", score: 3),
        RoboOption(text: "Up to 20%", score: 4),
        RoboOption(text: "More than 20%", score: 5),
      ],
    ),

    RoboQuestion(
      question:
          "If the market dropped 20% in a short period, how would you likely respond?",
      options: [
        RoboOption(
            text: "Sell all my investments to avoid further losses", score: 1),
        RoboOption(
            text: "Sell some of my investments to reduce risk exposure",
            score: 2),
        RoboOption(text: "Hold my investments and wait for recovery", score: 3),
        RoboOption(
            text: "Invest more to take advantage of lower prices", score: 4),
      ],
    ),

    RoboQuestion(
      question: "How do you feel about taking risks to achieve higher returns?",
      options: [
        RoboOption(
            text: "Very uncomfortable (I avoid risk entirely)", score: 1),
        RoboOption(
            text: "Somewhat uncomfortable (I’m cautious about taking risks)",
            score: 2),
        RoboOption(
            text:
                "Neutral (I’m willing to take some risk for moderate returns)",
            score: 3),
        RoboOption(
            text:
                "Comfortable (I understand and accept higher risks for higher returns)",
            score: 4),
        RoboOption(
            text:
                "Very comfortable (I actively seek higher-risk, high-reward investments)",
            score: 5)
      ],
    ),
    RoboQuestion(
      question: "How much experience do you have with investing?",
      options: [
        RoboOption(text: "None (I’m new to investing)", score: 1),
        RoboOption(
            text:
                "Limited (I’ve invested in a few basic instruments like savings accounts or bonds)",
            score: 2),
        RoboOption(
            text:
                "Moderate (I’ve invested in stocks, ETFs, or mutual funds but don’t track them often)",
            score: 3),
        RoboOption(
            text:
                "Extensive (I actively manage my portfolio and understand advanced investment strategies)",
            score: 4)
      ],
    ),

    RoboQuestion(
      question:
          "What percentage of your portfolio are you willing to allocate to higher-risk investments, such as stocks?",
      options: [
        RoboOption(
            text: "0% (I prefer very safe, low-risk investments)", score: 1),
        RoboOption(text: "25%", score: 2),
        RoboOption(text: "50%", score: 3),
        RoboOption(text: "75%", score: 4),
        RoboOption(
            text:
                "100% (I am comfortable with full exposure to higher-risk investments)",
            score: 5)
      ],
    ),

//8
    RoboQuestion(
      question: "What is your annual income",
      options: [
        RoboOption(text: "Less than Rand 50,000", score: 1),
        RoboOption(text: "Rand 50,000 to Rand 100,000", score: 2),
        RoboOption(text: "Rand 100,000 to Rand 250,000", score: 3),
        RoboOption(text: "More than Rand 250,000", score: 4),
      ],
    ),

    RoboQuestion(
      question: "What is your annual Net Worth (excluding primary residence)",
      options: [
        RoboOption(text: "Less than Rand 50,000", score: 1),
        RoboOption(text: "Rand 50,000 to Rand 200,000", score: 2),
        RoboOption(text: "Rand 200,000 to Rand 1,000,000", score: 3),
        RoboOption(text: "More than Rand 1,000,000", score: 4),
      ],
    ),

    RoboQuestion(
      question: "What are your current liabilities and financial obligations?",
      options: [
        RoboOption(
            text:
                "I have significant debt (e.g., loans, mortgages) and high monthly expenses",
            score: 1),
        RoboOption(
            text: "I have some manageable debt and moderate expenses",
            score: 2),
        RoboOption(
            text: "I have minimal debt and low monthly expenses", score: 3),
        RoboOption(
            text: "I have no debt and low or manageable monthly expenses",
            score: 4)
      ],
    ),

    RoboQuestion(
      question:
          "How do you typically feel about volatility in your investments?",
      options: [
        RoboOption(
            text:
                "I avoid it at all costs (I prefer stable returns with minimal fluctuations)",
            score: 1),
        RoboOption(
            text: "I accept minor fluctuations for slightly higher returns",
            score: 2),
        RoboOption(
            text:
                "I don’t mind moderate ups and downs as long as I achieve good returns over time",
            score: 3),
        RoboOption(
            text:
                "I thrive on high volatility and am comfortable with significant short-term risks for higher potential long-term gains",
            score: 4)
      ],
    ),
  ];

  int currentQuestionIndex = 0;

  void selectAnswer(int score) {
    selectedAnswers[currentQuestionIndex] = score;
    totalScore += score;

    if (currentQuestionIndex + 1 >= roboQuestions.length) {
      setState(() => isFinished = true);
    } else {
      setState(() => currentQuestionIndex++);
    }
  }

  String getRiskProfile() {
    if (totalScore <= 10) return "Conservative";
    if (totalScore <= 18) return "Moderate";
    return "Aggressive";
  }

  @override
  @override
  Widget build(BuildContext context) {
    final question = roboQuestions[currentPage];

    return Scaffold(
        backgroundColor: AppColors.darBlue,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Robo Advisor",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins')),
                SizedBox(height: 4),
                Text("Select your options",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'poppins')),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SvgPicture.asset(
                'assets/icons/user_robot.svg',
                width: 40,
                height: 40,
              ),
            ),
          ],
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
                // child: SingleChildScrollView(
                //   // Enables scrolling if content is too much
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: [
                //       // Your form content here

                //     ],
                //   ),

                //   //new footer
                // ),

                child: isFinished
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    "🎯 Your Risk Profile:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darBlue),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(getRiskProfile(),
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.blue)),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate to details screen
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.darBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 70, vertical: 12),
                                  ),
                                  child: Text(
                                    "Finish",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.question,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 6),
                          ...List.generate(question.options.length,
                              (optionIndex) {
                            final option = question.options[optionIndex];
                            return RadioListTile<int>(
                              value: optionIndex,
                              groupValue: selectedAnswers[currentPage],
                              activeColor: AppColors.darBlue,
                              onChanged: (value) {
                                if (value == null) return;

                                setState(() {
                                  selectedAnswers[currentPage] = value;
                                });

                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  setState(() {
                                    totalScore += question.options[value].score;

                                    if (currentPage + 1 >=
                                        roboQuestions.length) {
                                      isFinished = true;
                                    } else {
                                      currentPage++;
                                    }
                                  });
                                });
                              },
                              title: Text(
                                option.text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.darBlue,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
              ),
            ),
          ],
        ));
  }
}

class RoboQuestion {
  final String question;
  final List<RoboOption> options;

  RoboQuestion({required this.question, required this.options});
}

class RoboOption {
  final String text;
  final int score;

  RoboOption({required this.text, required this.score});
}
