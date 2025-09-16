import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeePage extends StatefulWidget {
  final String token;
  const EmployeePage({super.key, required this.token});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  List employees = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    setState(() => loading = true);
    try {
      final String response =
      await rootBundle.loadString('data/employees.json');
      final data = await json.decode(response);
      setState(() => employees = data);
    } catch (e) {
      print('Error loading employees: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees & Operations'),
        backgroundColor: Colors.indigo,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : employees.isEmpty
          ? const Center(child: Text('No employees available'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final emp = employees[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.pink,
                child: Text(
                  emp['name'][0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                emp['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  "Role: ${emp['role']}\nEmail: ${emp['email']}\nPhone: ${emp['phone']}"),
            ),
          );
        },
      ),
    );
  }
}
