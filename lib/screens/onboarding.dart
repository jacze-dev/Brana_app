import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatefulWidget {
  static const routeName = '/onBoarding';
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  void initState() {
    setInstalledStatus();
    super.initState();
  }

  Future setInstalledStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isInstalled', true);
  }

  int index = 0;

  List<Map<String, String>> onBoardingItem = [
    {
      "txt":
          " Capture the gems of knowledge in your notebook, for they will be the stepping stones to your dreams and aspirations.",
      "img": "asset/svg/onboarding1.jpg"
    },
    {
      "txt":
          " Capture the gems of knowledge in your notebook, for they will be the.",
      "img": "asset/svg/onboarding2.jpg"
    },
    {
      "txt": " Capture the gems of knowledge in your notebook",
      "img": "asset/svg/onboarding3.jpg"
    },
  ];

  bool onLastPage = false;
  int _index = 0;

  final _controller = PageController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    onLastPage = index == 2;
                    _index = index;
                  });
                },
                children: [
                  Column(
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Lottie.asset('asset/lotties/note_taking.json'),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      Container(
                        child: const Text(
                                'Welcome to Your Notebook Journey! Capture Your Thoughts, Ideas, and Quotes',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w900))
                            .animate()
                            .slideY(
                                delay: const Duration(seconds: 1),
                                duration: const Duration(seconds: 1))
                            .fadeIn(duration: const Duration(seconds: 2)),
                        // decoration: BoxDecoration(),
                        // transform: Matrix4.diagonal3(),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.033,
                        ),
                        Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Center(
                            child: Lottie.asset('asset/lotties/quote.json'),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                            top: size.height * 0.07,
                            left: size.height * 0.01,
                            right: size.height * 0.01,
                            bottom: size.height * 0.02,
                          ),

                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02),
                            child: const Text('Store Your Favorite Quotes',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'Lato',
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900))
                                .animate()
                                .slideX(
                                    delay: const Duration(seconds: 1),
                                    duration: const Duration(seconds: 1))
                                .fadeIn(duration: const Duration(seconds: 2)),
                          ),
                          // decoration: BoxDecoration(),
                          // transform: Matrix4.diagonal3(),
                        ),
                        Container(
                          color: Colors.white,
                          // padding: EdgeInsets.only(
                          //     top: size.height * 0.1),
                          // height: size.height * 0.1,
                          child: const Text(
                                  textAlign: TextAlign.center,
                                  'Collect and store your favorite quotes for inspiration, motivation, and reflection. Let your notebook be a source of wisdom and positivity, always available whenever you need a boost.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Lato',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900))
                              .animate()
                              .slideY(
                                  begin: 5,
                                  end: 0,
                                  delay: const Duration(seconds: 1),
                                  duration: const Duration(seconds: 1))
                              .fadeIn(duration: const Duration(seconds: 2)),
                          // decoration: BoxDecoration(),
                          // transform: Matrix4.diagonal3(),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        child: Center(
                          child: Lottie.asset('asset/lotties/up_loading.json'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: size.height * 0.17,
                            bottom: size.height * 0.01),

                        child: const Text('Sync Across Devices',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w900))
                            .animate()
                            .slideX(
                                begin: 10,
                                end: 0,
                                delay: const Duration(seconds: 2),
                                duration: const Duration(seconds: 1))
                            .fadeIn(duration: const Duration(seconds: 2)),
                        // decoration: BoxDecoration(),
                        // transform: Matrix4.diagonal3(),
                      ),
                      SizedBox(
                        // padding: EdgeInsets.only(
                        //     top: size.height * 0.1),
                        height: size.height * 0.1,
                        child: const Text(
                                textAlign: TextAlign.center,
                                'Your notes and quotes are securely synced across all your devices. Start a note on your phone and finish it on your tablet or laptop. Your notebook is always with you, no matter where you are.',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w900))
                            .animate()
                            .slideY(
                                begin: -5,
                                end: 0,
                                delay: const Duration(seconds: 1),
                                duration: const Duration(seconds: 1))
                            .fadeIn(duration: const Duration(seconds: 2)),
                        // decoration: BoxDecoration(),
                        // transform: Matrix4.diagonal3(),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                alignment: const Alignment(0, 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          _controller.jumpToPage(2);
                        },
                        child: Text(
                          "Skip",
                          style: _index == 1
                              ? const TextStyle(color: Colors.black)
                              : Theme.of(context).textTheme.titleSmall,
                        )),
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: ExpandingDotsEffect(
                          activeDotColor: _index == 1
                              ? Colors.black
                              : Theme.of(context).colorScheme.secondary,
                          dotColor: Theme.of(context).colorScheme.onPrimary),
                    ),
                    onLastPage
                        ? TextButton(
                            onPressed: () async {
                              Navigator.of(context)
                                  .pushReplacementNamed('startPage');
                            },
                            child: Text(
                              "Done",
                              style: Theme.of(context).textTheme.titleSmall,
                            ))
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                _controller.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              });
                            },
                            child: Text(
                              "Next",
                              style: _index == 1
                                  ? const TextStyle(color: Colors.black)
                                  : Theme.of(context).textTheme.titleSmall,
                            )),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
