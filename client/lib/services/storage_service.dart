import 'dart:io';
import 'package:dio/dio.dart';

class StorageService {
  static const String _imgbbKey = 'b77a181d7ced861eee29cbf45e7771e2';
  static final Dio _dio = Dio();

  static Future<String> uploadWastePhoto({
    required File imageFile,
    required String userId,
    void Function(double progress)? onProgress,
  }) async {
    final fileName = imageFile.path.split('/').last;
    final formData = FormData.fromMap({
      'key': _imgbbKey,
      'image': await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    final response = await _dio.post(
      'https://api.imgbb.com/1/upload',
      data: formData,
      onSendProgress: (sent, total) {
        if (total > 0) {
          onProgress?.call(sent / total);
        }
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['data']['url'];
    } else {
      throw Exception('Failed to upload image to ImgBB');
    }
  }

  static Future<void> deletePhoto(String url) async {
    // ImgBB API doesn't support direct deletion without the delete_url
    // or passing an expiration time. We'll ignore delete requests.
    return;
  }
}
