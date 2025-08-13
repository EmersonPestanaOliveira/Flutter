import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = context.watch<ImageChangeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nasa Images'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => imageProvider.fetchImages(),
            child: const Text('Carregar Imagens'),
          ),
          if (imageProvider.isLoading)
            const CircularProgressIndicator()
          else if (imageProvider.errorMessage != null)
            Text(imageProvider.errorMessage!)
          else
            Expanded(
              child: ListView.builder(
                itemCount: imageProvider.images.length,
                itemBuilder: (context, index) {
                  final image = imageProvider.images[index];
                  return ListTile(
                    leading: Image.network(image.url, width: 50, height: 50),
                    title: Text(image.title),
                    subtitle: Text(image.explanation),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
