import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:circular_selector_v2/circular_selector_v2.dart';
import 'package:wear/wear.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Add this import for time formatting

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFF5F5DC), // Primary Beige color
          secondary: Color(0xFFD8CAB8), // Secondary Beige Accent color
        ),
        scaffoldBackgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF5F5DC), // Primary Beige color
          secondary: Color(0xFFD8CAB8), // Secondary Beige Accent color
        ),
        scaffoldBackgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      routes: {
        '/person': (context) => PersonPage(),
        '/notifications': (context) => NotificationsPage(),
        '/nightlight': (context) => NightlightPage(),
        '/volume': (context) => VolumePage(),
        '/sunny': (context) => SunnyPage(),
        '/settings': (context) => SettingsPage(),
        '/home': (context) => const HomePage(),
        '/logout': (context) => LogoutPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm');
    setState(() {
      _currentTime = formatter.format(now);
    });
    Future.delayed(const Duration(minutes: 1) - Duration(seconds: now.second), _updateTime);
  }

  void onItemSelected(int selectorIndex, int index) {
    if (kDebugMode) {
      print('Selected: $index of selector $selectorIndex');
    }
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/person');
        break;
      case 1:
        Navigator.pushNamed(context, '/notifications');
        break;
      case 2:
        Navigator.pushNamed(context, '/nightlight');
        break;
      case 3:
        Navigator.pushNamed(context, '/volume');
        break;
      case 4:
        Navigator.pushNamed(context, '/sunny');
        break;
      case 5:
        Navigator.pushNamed(context, '/settings');
        break;
      case 6:
        Navigator.pushNamed(context, '/home');
        break;
      case 7:
        Navigator.pushNamed(context, '/logout');
        break;
    }
  }

  void _handleRotaryInput(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      setState(() {
        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          _selectedIndex =
              (_selectedIndex + 1) % 6; // Assuming 6 items in the selector
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          _selectedIndex =
              (_selectedIndex - 1 + 6) % 6; // Ensure index wraps around
        }
        onItemSelected(0, _selectedIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return InheritedShape(
          shape: shape,
          child: AmbientMode(
            builder: (context, mode, child) {
              return Scaffold(
                body: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: _handleRotaryInput,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double width = constraints.maxWidth;
                      double height = constraints.maxHeight;
                      double childSize =
                          width * 0.1; // Adjust size relative to width
                      double radiusDividend = 2.0;
                      double customOffsetY = MediaQuery.of(context).padding.top;

                      return Center(
                        child: Container(
                          width: width,
                          height: height,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularSelector(
                                onSelected: (index) => onItemSelected(0, index),
                                childSize: childSize,
                                radiusDividend: radiusDividend,
                                customOffset: Offset(
                                  0.0,
                                  customOffsetY,
                                ),
                                circleBackgroundColor: Colors.grey.shade900,
                                children: List.generate(6, (index) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getIconForIndex(index),
                                      size: 20,
                                      color: Colors.white, // Set icon color to white
                                    ),
                                  );
                                }),
                              ),
                              Center(
                                child: Text(
                                  _currentTime,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.person;
      case 1:
        return Icons.notifications;
      case 2:
        return Icons.nightlight;
      case 3:
        return Icons.volume_up;
      case 4:
        return Icons.wb_sunny;
      case 5:
        return Icons.settings;
      default:
        return Icons.help;
    }
  }

  IconData _getSecondaryIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home_filled;
      case 1:
        return Icons.logout;
      default:
        return Icons.help;
    }
  }
}

// Placeholder pages for each icon
class PersonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Person Page")),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Notifications Page")),
    );
  }
}

class NightlightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Focus Page")),
    );
  }
}

class VolumePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Volume Page")),
    );
  }
}

class SunnyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Brightness Page")),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Settings Page")),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Home Page")),
    );
  }
}

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Close the app
    Future.delayed(Duration.zero, () {
      SystemNavigator.pop();
    });

    return const Scaffold(
      body: Center(child: Text("Exiting...")),
    );
  }
}