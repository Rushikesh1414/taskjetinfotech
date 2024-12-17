
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Homepage extends StatelessWidget {
  // URLs of the images
  final String imageUrl1 = 'https://chhavinirman.com/uploads/posts/1732014653_dipavaliPost.jpg';
  final String imageUrl2 = 'https://chhavinirman.com/uploads/avatar/photopatti_top_7.png';

  const Homepage({super.key});


  // Function to download an image
  Future<void> downloadImage(BuildContext context, String imageUrl, String imageName) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Downloading...')),
      );

      // Fetch the image data
      final response = await http.get(Uri.parse(imageUrl));
      var data = response.body.toString();
      if (response.statusCode == 200) {
        // Get the directory to save the file
        print(data);
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$imageName';

        // Save the image to the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image downloaded: $filePath')),
        );
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to download image')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.network(
            imageUrl1,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Foreground Image
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.network(
                imageUrl2,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              // Download Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Download both images
                    await downloadImage(context, imageUrl1, 'background_image.jpg');
                    await downloadImage(context, imageUrl2, 'foreground_image.png');
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download Images'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
