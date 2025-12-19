import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// Holds the Cloudinary credentials required for unsigned uploads.
class CloudinaryConfig {
  const CloudinaryConfig({
    required this.cloudName,
    required this.uploadPreset,
    this.apiKey,
    this.apiSecret,
  });

  final String cloudName;
  final String uploadPreset;
  final String? apiKey;
  final String? apiSecret;

  /// Default DevMind workspace configuration.
  static const defaultConfig = CloudinaryConfig(
    cloudName: 'dtyyorbhn',
    uploadPreset: 'hrilin',
    apiKey: '178497716748418',
    apiSecret: 'FyIJXI_s3IL_9KhTgTo-Vn-1SDg',
  );
}

/// Simple response model for the most common Cloudinary fields.
class CloudinaryUploadResult {
  CloudinaryUploadResult({
    required this.secureUrl,
    required this.publicId,
    required this.version,
    this.originalFilename,
  });

  final String secureUrl;
  final String publicId;
  final int version;
  final String? originalFilename;

  factory CloudinaryUploadResult.fromJson(Map<String, dynamic> json) {
    return CloudinaryUploadResult(
      secureUrl: json['secure_url'] as String? ?? '',
      publicId: json['public_id'] as String? ?? '',
      version: json['version'] is int
          ? json['version'] as int
          : int.tryParse('${json['version']}') ?? 0,
      originalFilename: json['original_filename'] as String?,
    );
  }
}

class CloudinaryException implements Exception {
  CloudinaryException(this.message, [this.details]);

  final String message;
  final String? details;

  @override
  String toString() =>
      'CloudinaryException: $message${details == null ? '' : ' -> $details'}';
}

/// Common helper for pushing raw image bytes to Cloudinary using multipart uploads.
class CloudinaryService {
  CloudinaryService({CloudinaryConfig? config})
      : _config = config ?? CloudinaryConfig.defaultConfig;

  final CloudinaryConfig _config;

  Future<CloudinaryUploadResult> uploadBytes({
    required Uint8List bytes,
    required String fileName,
    String resourceType = 'image',
    String? folder,
    Map<String, String>? additionalFields,
  }) async {
    final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/${_config.cloudName}/$resourceType/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _config.uploadPreset;
    if (_config.apiKey != null) {
      request.fields['api_key'] = _config.apiKey!;
    }

    if (folder != null && folder.isNotEmpty) {
      request.fields['folder'] = folder;
    }

    if (additionalFields != null && additionalFields.isNotEmpty) {
      request.fields.addAll(additionalFields);
    }

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
      ),
    );

    final client = http.Client();
    try {
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> body =
            jsonDecode(response.body) as Map<String, dynamic>;
        return CloudinaryUploadResult.fromJson(body);
      }
      final errorBody = response.body;
      // Surface detailed error info in logs for easier debugging
      // without exposing it to end users by default.
      // ignore: avoid_print
      print(
        'Cloudinary upload failed (${response.statusCode}): $errorBody',
      );
      throw CloudinaryException(
        'Upload failed with status ${response.statusCode}',
        errorBody,
      );
    } finally {
      client.close();
    }
  }

  /// Accepts a base64/data URL string and forwards to [uploadBytes].
  Future<CloudinaryUploadResult> uploadBase64({
    required String data,
    required String fileName,
    String resourceType = 'image',
    String? folder,
    Map<String, String>? additionalFields,
  }) {
    final normalized = data.split(',').last;
    final bytes = base64Decode(normalized);
    return uploadBytes(
      bytes: bytes,
      fileName: fileName,
      resourceType: resourceType,
      folder: folder,
      additionalFields: additionalFields,
    );
  }
}
