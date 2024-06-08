// ignore_for_file: dead_code

import 'dart:io';
import 'dart:ui';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:appscript/screens/first_screen.dart';
// import 'package:appscript/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:appscript/utilities/text_utils.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_made_easy/auth2.dart';
import 'package:pdf_made_easy/first_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void navigateWithFadeAnimation(BuildContext context, Widget page) {
  Navigator.of(context).push(FadeRoute(page: page));
}

class DisableBackButton extends StatelessWidget {
  final Widget child;

  const DisableBackButton({required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: child,
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen();

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  SharedPreferences? prefs;
  bool authing = false;

  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    prefs?.setBool('rememberRank', true);
    prefs?.setBool('enabledDistCalc', false);
    prefs?.setBool('rememberLocation', true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpeg'),
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            height: 600,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/images/logo.jpg',
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                        const Gap(8),
                        Center(
                          child: Text(
                            "Welcome to Quick Docs",
                            style: GoogleFonts.exo2(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Effortlessly manage and retrieve your digital documents with our intelligent search system. Say goodbye to wasted time and hello to productivity with Magic Search with Quick Docs.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Spacer(),

                        !authing
                            ? SingleChildScrollView(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return SafeArea(
                                                child: Auth2(),
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Sign in",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Gap(10),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return SafeArea(
                                                child: Auth2(
                                                  signup: true,
                                                ),
                                              );
                                            });
                                      },
                                      // showBottomSheet(
                                      //     context: context,
                                      //     builder: (context) {
                                      //       return Auth2(
                                      //         signup: true,
                                      //       );
                                      //     })
                                      //     ;
                                      // Navigator.of(context).push(FadeRoute(
                                      //     page: Auth2(
                                      //   signup: true,
                                      // )));
                                      // },
                                      child: Container(
                                        height: 40,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                133, 255, 255, 255),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Sign up",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                        // ),
                        // TextUtil(
                        //   text: "Password",
                        // ),
                        // Container(
                        //   height: 35,
                        //   decoration: const BoxDecoration(
                        //     border: Border(
                        //       bottom: BorderSide(color: Colors.white),
                        //     ),
                        //   ),
                        //   child: TextFormField(
                        //     style: const TextStyle(color: Colors.white),
                        //     decoration: const InputDecoration(
                        //       suffixIcon: Icon(
                        //         Icons.lock,
                        //         color: Colors.white,
                        //       ),
                        //       fillColor: Colors.white,
                        //       border: InputBorder.none,
                        //     ),
                        //   ),
                        // ),
                        const Spacer(),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
