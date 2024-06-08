import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Auth2 extends StatelessWidget {
  Auth2({this.signup = false});
  bool signup = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: signup ? const Text('Sign up') : const Text('Sign in'),
          leading: TextButton(
            child: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Center(
            // child: ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => AuthScreen()),
            //     );
            //   },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('Welcome to PDF Made Easy',
                      style: TextStyle(fontSize: 20)),
                  const Gap(4),
                  if (signup) const Text('Please sign up to continue'),
                  const Gap(10),
                  if (!signup) const Text('Please sign in to continue'),
                  const Gap(10),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  const Gap(10),
                  const TextField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  if (!signup)
                    ElevatedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                            width: 2,
                          ),
                        ),
                      ),
                      onPressed: () {
                        // Navigator.pushNamed(context, '/auth');
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      },
                      child: const Text('Sign in'),
                    ),
                  const Gap(4),
                  if (signup)
                    ElevatedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                            width: 2,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        // Navigator.pushNamed(context, '/auth');
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          Future.delayed(const Duration(seconds: 1), () async {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          });
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }
                        // FirebaseAuth.instance.signInWithEmailAndPassword(
                        //   email: emailController.text,
                        //   password: passwordController.text,
                        // );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'User created and signed in successfully!'),
                          ),
                        );
                      },
                      child: const Text('Sign up'),
                    ),
                ],
              ),
            ),
            //   ),
          ),
        ),
      ),
    );
  }
}
