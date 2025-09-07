import 'package:flutter/material.dart';
import 'package:provider_test/features/provider/dashboard_provider.dart';
import 'package:provider_test/features/widgets/custom_icon_button.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons.map((btn) {
            return Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => btn["page"]),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(btn["icon"], size: 32, color: Colors.grey[700]),
                    const SizedBox(height: 6),
                    Text(btn["label"], style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
