import 'package:flutter/material.dart';


class CamerasPage extends StatelessWidget {
  const CamerasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'https://source.unsplash.com/random/200x200?house1',
      'https://source.unsplash.com/random/200x200?house2',
      'https://source.unsplash.com/random/200x200?house3',
      'https://source.unsplash.com/random/200x200?house4',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Security Cameras')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imageUrls[index], fit: BoxFit.cover),
            );
          },
        ),
      ),
    );
  }
}
