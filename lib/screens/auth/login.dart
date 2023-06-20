import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:historia/screens/home_page.dart';
import 'package:historia/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

String userName = 'User';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
// ignore: unused_element
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  void _togglePage(bool _switchme) {
    setState(() {
      _pageLogin = _switchme;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.currentThemeMode == ThemeMode.dark
          ? Colors.black
          : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 138, 113, 247),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0, top: 15.0),
                        child: IconButton(
                          iconSize: 35.0,
                          icon: themeProvider.currentThemeMode == ThemeMode.dark
                              ? const Icon(Icons.nightlight_round,
                                  color: Colors.black)
                              : const Icon(Icons.wb_sunny, color: Colors.white),
                          onPressed: () {
                            final newThemeMode =
                                themeProvider.currentThemeMode == ThemeMode.dark
                                    ? ThemeMode.light
                                    : ThemeMode.dark;
                            themeProvider.setThemeMode(newThemeMode);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 170.0,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 138, 113, 247),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    _pageLogin ? 'Welcome Back!' : 'Create an Account',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.currentThemeMode == ThemeMode.dark
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 0,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      color: _pageLogin
                          ? const Color.fromARGB(255, 138, 113, 247)
                          : themeProvider.currentThemeMode == ThemeMode.dark
                              ? Colors.black
                              : Colors.white,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: _pageLogin
                              ? themeProvider.currentThemeMode == ThemeMode.dark
                                  ? Colors.black
                                  : Colors.white
                              : const Color.fromARGB(255, 138, 113, 247),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _pageLogin = true;
                        });
                      },
                    ),
                    MaterialButton(
                      minWidth: 0,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      color: _pageLogin
                          ? themeProvider.currentThemeMode == ThemeMode.dark
                              ? Colors.black
                              : Colors.white
                          : const Color.fromARGB(255, 138, 113, 247),
                      child: Text(
                        'SignUp',
                        style: TextStyle(
                          color: _pageLogin
                              ? const Color.fromARGB(255, 138, 113, 247)
                              : themeProvider.currentThemeMode == ThemeMode.dark
                                  ? Colors.black
                                  : Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _pageLogin = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              _pageLogin
                  ? Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            style: TextStyle(
                              color: themeProvider.currentThemeMode ==
                                      ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            style: TextStyle(
                              color: themeProvider.currentThemeMode ==
                                      ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: _login,
                            child: const Text('Login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 138, 113, 247),
                              textStyle: TextStyle(
                                color: themeProvider.currentThemeMode ==
                                        ThemeMode.dark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: () {
                              _togglePage(false);
                            },
                            child: const Text(
                              'Not signed up yet? Sign up here',
                              style: TextStyle(
                                color: Color.fromARGB(255, 138, 113, 247),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            style: TextStyle(
                              color: themeProvider.currentThemeMode ==
                                      ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            style: TextStyle(
                              color: themeProvider.currentThemeMode ==
                                      ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            style: TextStyle(
                              color: themeProvider.currentThemeMode ==
                                      ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            style: TextStyle(
                              color: themeProvider.currentThemeMode ==
                                      ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: _signup,
                            child: const Text('SignUp'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 138, 113, 247),
                              textStyle: TextStyle(
                                color: themeProvider.currentThemeMode ==
                                        ThemeMode.dark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: () {
                              _togglePage(true);
                            },
                            child: const Text(
                              'Already have an account? Login here',
                              style: TextStyle(
                                color: Color.fromARGB(255, 138, 113, 247),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  bool _pageLogin = true;

  Future<void> _login() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Validation Error'),
              content: const Text('Please fill in all the required fields.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Successful'),
            content: const Text('You have successfully logged in.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid email or password. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _signup() async {
    try {
      final String name = _nameController.text.trim();
      userName = name;
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String confirmPassword = _confirmPasswordController.text.trim();

      if (name.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Validation Error'),
              content: const Text('Please fill in all the required fields.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      if (password != confirmPassword) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Validation Error'),
              content: const Text('Passwords do not match. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('SignUp Successful'),
            content: const Text('You have successfully signed up.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('SignUp Failed'),
            content: const Text(
                'An error occurred during the signup process. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
