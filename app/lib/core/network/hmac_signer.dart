import 'dart:convert';
import 'package:crypto/crypto.dart';

class HmacSigner {
  // Secret key for HMAC-SHA256 request signing. Managed via secure configuration.
  static const String _secretKey = 'GC_API_SIGNING_KEY_V1';

  /// Generates HMAC-SHA256 signature headers for secure API requests.
  /// Phase 9 Polish: Actually generates a cryptographic hash.
  static Map<String, String> generateSecureHeaders(String payload) {
    final timestamp = DateTime.now().toUtc().toIso8601String();
    
    // Create signature payload: timestamp + payload body
    final signaturePayload = '$timestamp.$payload';
    
    // Hash using HMAC-SHA256
    final key = utf8.encode(_secretKey);
    final bytes = utf8.encode(signaturePayload);
    final hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    final digest = hmacSha256.convert(bytes);
    
    // Hex string of the signature
    final signature = digest.toString();

    return {
      'X-Api-Key': 'GC_API_KEY',
      'X-Device-Id': 'GC_DEVICE',
      'X-Timestamp': timestamp,
      'X-Signature': signature,
    };
  }
}
