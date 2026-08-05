import 'package:flutter/material.dart';
import 'services/game_state.dart';
import 'screens/home_screen.dart';
import 'screens/radar_screen.dart';
import 'screens/ayllu_screen.dart';
import 'theme/andean_theme.dart';

void main() {
  runApp(const AmuyuniApp());
}

class AmuyuniApp extends StatelessWidget {
  const AmuyuniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: 'Amuyuni',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(
            seedColor: AndeanColors.primary,
            primary: AndeanColors.primary,
            secondary: AndeanColors.secondary,
            surface: AndeanColors.surface,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: AndeanColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
          ),
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}

class ChangeNotifierProvider extends StatefulWidget {
  final GameState Function(BuildContext) create;
  final Widget child;

  const ChangeNotifierProvider({
    super.key,
    required this.create,
    required this.child,
  });

  @override
  State<ChangeNotifierProvider> createState() => _ChangeNotifierProviderState();

  static GameState of(BuildContext context) {
    final state = context
        .dependOnInheritedWidgetOfExactType<_InheritedGameState>()!
        .state;
    return state;
  }

  static GameState read(BuildContext context) {
    final state = context
        .getInheritedWidgetOfExactType<_InheritedGameState>()!
        .state;
    return state;
  }
}

class _ChangeNotifierProviderState extends State<ChangeNotifierProvider> {
  late final GameState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.create(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _state,
      builder: (context, _) {
        return _InheritedGameState(
          state: _state,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }
}

class _InheritedGameState extends InheritedWidget {
  final GameState state;

  const _InheritedGameState({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _InheritedGameState oldWidget) => true;
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    RadarScreen(),
    AylluScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AndeanColors.textDark.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          indicatorColor: AndeanColors.primary.withValues(alpha: 0.12),
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.school_outlined, color: AndeanColors.greyCool),
              selectedIcon:
                  Icon(Icons.school, color: AndeanColors.primary),
              label: 'Aprende',
            ),
            NavigationDestination(
              icon: Icon(Icons.radar_outlined, color: AndeanColors.greyCool),
              selectedIcon: Icon(Icons.radar, color: AndeanColors.primary),
              label: 'Radar',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline, color: AndeanColors.greyCool),
              selectedIcon: Icon(Icons.people, color: AndeanColors.primary),
              label: 'Mi Ayllu',
            ),
          ],
        ),
      ),
    );
  }
}
