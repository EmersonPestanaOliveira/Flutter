import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_MenuItem> menuItems = [
      _MenuItem(
        title: 'Clientes',
        icon: Icons.people,
        color: Colors.pinkAccent,
        route: '/clients',
      ),
      _MenuItem(
        title: 'Consultas',
        icon: Icons.calendar_month,
        color: Colors.purpleAccent,
        route: '/agenda',
      ),
      _MenuItem(
        title: 'Produtos',
        icon: Icons.shopping_bag,
        color: Colors.blueAccent,
        route: '/products',
      ),
      _MenuItem(
        title: 'Financeiro',
        icon: Icons.attach_money,
        color: Colors.green,
        route: '/financial',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manju', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_home.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 32,
              children: menuItems.map((item) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, item.route);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, size: 48, color: item.color),
                        const SizedBox(height: 12),
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  _MenuItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}
