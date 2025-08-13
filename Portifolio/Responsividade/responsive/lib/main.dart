import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela Responsiva',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ResponsiveScreen(),
    );
  }
}

class ResponsiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Responsiva'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Obtem largura da tela para decidir layout
          double width = constraints.maxWidth;

          if (width < 600) {
            // Layout para celular com baixa resolução
            return _buildMobileLowResLayout(context);
          } else if (width < 900) {
            // Layout para celular com alta resolução
            return _buildMobileHighResLayout(context);
          } else {
            // Layout para tablet
            return _buildTabletLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildMobileLowResLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mobile (Baixa Resolução)',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 10),
          Image.network(
            'https://occ-0-8407-1722.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABeNzg-kMHhUBP4AmHnLsrPYzxKHVceLnkwtLhxZlDssj7KjhStloJR6px7EbquZ83uDcygnWkekxysvuNYVzLQ3GyBMRl2PpU7pO.jpg?r=db8',
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.star),
                title: Text('Item $index'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHighResLayout(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(8.0),
      crossAxisCount: 2,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      children: [
        Container(
          color: Colors.blue,
          child: Center(
            child: Text(
              'Alta Resolução',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Image.network(
            'https://occ-0-8407-1722.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABeNzg-kMHhUBP4AmHnLsrPYzxKHVceLnkwtLhxZlDssj7KjhStloJR6px7EbquZ83uDcygnWkekxysvuNYVzLQ3GyBMRl2PpU7pO.jpg?r=db8',
            fit: BoxFit.cover),
        ...List.generate(6, (index) {
          return Card(
            child: Center(
              child: Text('Card $index'),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tablet Layout',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 100),
              Image.network(
                'https://occ-0-8407-1722.1.nflxso.net/dnm/api/v6/6AYY37jfdO6hpXcMjf9Yu5cnmO0/AAAABeNzg-kMHhUBP4AmHnLsrPYzxKHVceLnkwtLhxZlDssj7KjhStloJR6px7EbquZ83uDcygnWkekxysvuNYVzLQ3GyBMRl2PpU7pO.jpg?r=db8',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.star),
                title: Text('Item $index'),
              );
            },
          ),
        ),
      ],
    );
  }
}
