import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/test_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();

    // Load role from SharedPreferences via provider
    Future.microtask(() {
      final provider = Provider.of<TestProvider>(context, listen: false);
      provider.readValue1();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Center(
        child: Consumer<TestProvider>(
          builder: (context, provider, child) {
            // Display role or empty string if null
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(provider.role ?? "", style: const TextStyle(fontSize: 24)),
              ],
            );
          },
        ),
      ),
    );
  }
}
