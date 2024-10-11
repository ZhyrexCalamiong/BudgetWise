import 'package:budgetwise_one/features/guide/pages/first_page.dart';
import 'package:budgetwise_one/features/guide/pages/second_page.dart';
import 'package:budgetwise_one/features/guide/pages/third_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final PageController _controller = PageController();

  bool lastpage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              lastpage = (index == 2);
            });
          },
          children: const [
            FirstPage(),
            SecondPage(),
            ThirdPage(),
          ],
        ),
        Stack(
          children: [
            // Skip button moved to bottom left
            if (!lastpage)
              Positioned(
                bottom: 20, // Padding from the bottom
                left: 20, // Padding from the left
                child: TextButton(
                  onPressed: () {
                    _controller.jumpToPage(2); // Jump to last page
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            lastpage
                ? Positioned(
                    bottom: 20, // Padding from the bottom
                    right: 20, // Padding from the right
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Navigate to HomePage
                      },
                      child: const Text(
                        "Return",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                : Positioned(
                    bottom: 20, // Padding from the bottom
                    right: 20, // Padding from the right
                    child: TextButton(
                      onPressed: () {
                        _controller.nextPage(
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
            // Centering the SmoothPageIndicator
            Positioned(
              bottom: 30, // Padding from the bottom
              left: 0, // Make sure it's full width
              right: 0, // Make sure it's full width
              child: Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const WormEffect(
                    dotHeight: 7, // Change dot height
                    dotWidth: 7, // Change dot width
                    spacing: 8, // Spacing between dots
                    activeDotColor: Color(0xff75ECE1), // Active dot color
                    dotColor: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
