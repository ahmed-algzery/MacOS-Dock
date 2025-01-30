import 'package:flutter/material.dart';
import 'dock.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (icon, isHovered, isDragged) {
              return AnimatedContainer(
                constraints: BoxConstraints(minWidth: isHovered ? 56 : 48),
                height: isHovered ? 56 : 48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:
                      Colors.primaries[icon.hashCode % Colors.primaries.length],
                ),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Center(child: Icon(icon, color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}
