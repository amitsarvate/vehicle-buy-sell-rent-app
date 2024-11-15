import 'package:flutter/material.dart';
import 'authService.dart';
import 'main.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controlloer = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Add listener to clear input fields when switching tabs
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _clearTextFields();
      }
    });
  }

  void _clearTextFields() {
    _emailController.clear();
    _passwordController.clear();
    _password2Controlloer.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    _password2Controlloer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Login & Signup',style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (context) => HomePage(title: "AutoHub",),
                )
            );
          },
        ),
        backgroundColor: Color(0xffe23636),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white, // Set label color to make text visible on white
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Login',),
            Tab(text: 'Signup'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _loginForm(context),
          _signupForm(context),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return _buildForm(context, "Welcome back", 'Enter your credentials',() {
      if (_formKey.currentState?.validate() == true) {
        final email = _emailController.text;
        final password = _passwordController.text;
        AuthService().signIn(context, email: email, password: password);
      }
    });
  }

  Widget _signupForm(BuildContext context) {
    return _buildForm(context, "Sign up",'Create your account', () {
      if (_formKey.currentState?.validate() == true) {
        final email = _emailController.text;
        final password = _passwordController.text;
       // final password2 = _
        AuthService().signUp(context, email: email, password: password);
      }
    });
  }

  Widget _buildForm(BuildContext context, String header,String subHeader, VoidCallback onSubmit) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                header,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(subHeader,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: onSubmit,
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
