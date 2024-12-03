import 'package:flutter/material.dart';
import 'authService.dart';
import 'main.dart';
import 'User.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controlloer = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
    _nameController.clear();
    _lastNameController.clear();
    _phoneController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controlloer.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Login & Signup', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(title: "AutoHub"),
              ),
            );
          },
        ),
        backgroundColor: Color(0xffe23636),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Login'),
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
    return _buildForm(
      context,
      "Welcome back",
      'Enter your credentials',
          () {
        if (_formKey.currentState?.validate() == true) {
          final email = _emailController.text;
          final password = _passwordController.text;
          AuthService().signIn(context, email: email, password: password);
        }
      },
    );
  }

  Widget _signupForm(BuildContext context) {
    return _buildSignupForm(
      context,
      "Sign up",
      'Create your account',
          () {
        if (_formKey.currentState?.validate() == true) {
          final email = _emailController.text;
          final password = _passwordController.text;
          final confirmPassword = _password2Controlloer.text;
          final name = _nameController.text;
          final lastName = _lastNameController.text;
          final phoneNumber = _phoneController.text;

          if (password != confirmPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Passwords do not match')),
            );
            return;
          }
          Map<String, dynamic> userData = {
            'name': name,
            'lastName': lastName,
            'email': email,
            'phoneNumber': phoneNumber,

          };

          AuthService().signUp(
            context,
            email: email,
            password: password,
            user: userData,

          );
        }
      },
    );
  }

  Widget _buildForm(BuildContext context, String header, String subHeader, VoidCallback onSubmit) {
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
              Text(
                subHeader,
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

  Widget _buildSignupForm(BuildContext context, String header, String subHeader, VoidCallback onSubmit) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                Text(
                  subHeader,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
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
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _password2Controlloer,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: onSubmit,
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
