import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/features/provider/test_provider.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    final testProvider = context.watch<TestProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Provider Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              " ${testProvider.a}",
              style: const TextStyle(fontSize: 34, color: Colors.green),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: testProvider.increaseValue,
                  child: const Text("Add"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: testProvider.decreaseValue,
                  child: const Text("Subtract"),
                ),
              ],
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: testProvider.toggleFavorite,
                  icon: Icon(
                    testProvider.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: testProvider.isFavorite ? Colors.red : Colors.grey,
                    size: 34,
                  ),
                ),
                Text(
                  "${testProvider.loveCounter}",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
