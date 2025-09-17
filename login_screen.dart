import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool loading = false;
  bool isLogin = true; // ✅ toggle between login/signup

  // ✅ Login API
  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter username and password")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final url = Uri.parse('http://localhost:3000/api/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': username, 'password': password}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data['token'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SplashScreen(token: token),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Server error')));
    } finally {
      setState(() => loading = false);
    }
  }

  // ✅ Register API
  Future<void> register() async {
    final name = signupNameController.text.trim();
    final email = signupEmailController.text.trim();
    final password = signupPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final url = Uri.parse('http://localhost:3000/api/auth/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful! Please login.")),
        );
        setState(() => isLogin = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Server error')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // ✅ Web/Desktop layout
            return Row(
              children: [
                Expanded(flex: 1, child: _buildLeftBranding()),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight,
                        maxWidth: 600,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          child: _buildRightLoginForm(padding: 30),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // ✅ Mobile layout
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Text(
                      "Smart Retail Management System",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _buildRightLoginForm(padding: 20),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLeftBranding() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/loginpic.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Smart Retail Management System",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Manage sales, inventory, and staff seamlessly.\nBoost productivity with AI-powered insights.",
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightLoginForm({double padding = 40}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ✅ Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isLogin = true),
                  child: _tabButton("Sign In", isLogin),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isLogin = false),
                  child: _tabButton("Sign Up", !isLogin),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ✅ Show Login or Signup form
          isLogin ? _buildLoginForm() : _buildSignupForm(),
        ],
      ),
    );
  }

  // ✅ Login Form (with social buttons)
  Widget _buildLoginForm() {
    return Column(
      children: [
        const Text(
          "Sign in to access your credits and discounts",
          style: TextStyle(fontSize: 14, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),

        // Social Buttons (full width)
        _socialButton("Continue with Google",
            Image.asset("assets/google.png", height: 20),
            Colors.blue.shade600, () {}),
        const SizedBox(height: 16),
        _socialButton("Continue with Facebook",
            const Icon(Icons.facebook, color: Colors.white),
            Colors.blue.shade800, () {}),
        const SizedBox(height: 16),
        _socialButton("Continue with Apple",
            Image.asset("assets/apple.webp", height: 20),
            Colors.black, () {}),

        const SizedBox(height: 30),
        const Center(child: Text("or continue with email")),
        const SizedBox(height: 20),

        _buildTextField("Email", usernameController, Icons.email_outlined),
        const SizedBox(height: 16),
        _buildTextField("Password", passwordController, Icons.lock_outline, obscure: true),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {}, child: const Text("Forgot your password?")),
        ),
        const SizedBox(height: 20),

        SizedBox(
          height: 50,
          width: double.infinity, // ✅ full width
          child: ElevatedButton(
            onPressed: login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Sign In", style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 20),

        // ✅ Switch to Sign Up
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don’t have an account? "),
            GestureDetector(
              onTap: () => setState(() => isLogin = false),
              child: const Text("Sign Up", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
          ],
        )
      ],
    );
  }

  // ✅ Signup Form
  Widget _buildSignupForm() {
    return Column(
      children: [
        _buildTextField("Name", signupNameController, Icons.person),
        const SizedBox(height: 16),
        _buildTextField("Email", signupEmailController, Icons.email_outlined),
        const SizedBox(height: 16),
        _buildTextField("Password", signupPasswordController, Icons.lock_outline, obscure: true),
        const SizedBox(height: 20),
        SizedBox(
          height: 50,
          width: double.infinity, // ✅ full width
          child: ElevatedButton(
            onPressed: register,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Sign Up", style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 20),

        // ✅ Switch to Sign In
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account? "),
            GestureDetector(
              onTap: () => setState(() => isLogin = true),
              child: const Text("Sign In", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
          ],
        )
      ],
    );
  }

  Widget _tabButton(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: active ? Colors.grey.shade300 : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: active ? Colors.black : Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _socialButton(String text, Widget iconWidget, Color color, VoidCallback onPressed) {
    return SizedBox(
      height: 50,
      width: double.infinity, // ✅ full width
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: iconWidget,
        label: Text(text),
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure ? obscurePassword : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: obscure
            ? IconButton(
          icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => obscurePassword = !obscurePassword),
        )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
