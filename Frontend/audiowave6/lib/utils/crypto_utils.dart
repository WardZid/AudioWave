import 'dart:convert'; // For base64 encoding/decoding
import 'package:crypton/crypton.dart';

String encryptData(String data, String publicKeyString) {
  try {
    // Decode the Base64 string to get the raw binary form
    List<int> binaryData = base64Decode(data);
    
    // Convert the binary data back to a string if needed, but ensure it's in binary form here
    String binaryString = String.fromCharCodes(binaryData);

    // Initialize the RSA public key from the string
    RSAPublicKey publicKey = RSAPublicKey.fromString(publicKeyString);

    // Encrypt the binary string
    return publicKey.encrypt(binaryString);
  } catch (e) {
    print(e.toString());
    throw e;
  }
}
