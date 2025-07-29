import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'dphtww2lz';
  static const String uploadPreset = 'ohru47wu';

  static Future<String?> uploadImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final response = await http.post(url, body: {
      'file': 'data:image/png;base64,$base64Image',
      'upload_preset': uploadPreset,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['secure_url'];
    } else {
      print('Erreur Cloudinary: ${response.body}');
      return null;
    }
  }
}
