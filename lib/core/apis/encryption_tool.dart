import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mms_app/core/storage/local_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sodium_libs/sodium_libs_sumo.dart';

class EncryptionTool {
  static late Sodium sodium;
  static late Directory applicationDocuments;

  static Future<void> init() async {
    sodium = await SodiumSumoInit.init();
    applicationDocuments = await getApplicationDocumentsDirectory();
  }

  static KeyPair generatePair() {
    KeyPair keyPair = sodium.crypto.box.keyPair();
    return keyPair;
  }

  static bool shitTestKeyPair(String pubKey, String secretKey) {
    try {
      Uint8List data = base64Decode('data');
      Uint8List pub = base64Decode(pubKey);
      Uint8List secret = base64Decode(secretKey);

      /// seal the [data] with public key
      final encrypted = sodium.crypto.box.seal(message: data, publicKey: pub);

      /// unseal the [data] with given public and private keys
      final decrypted = sodium.crypto.box.sealOpen(
        cipherText: encrypted,
        publicKey: pub,
        secretKey: SecureKey.fromList(sodium, secret),
      );
      return listEquals(decrypted, data);
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<EncryptedFile> encryptData(File file) async {
    final Uint8List messageBytes = await file.readAsBytes();
    print('normal data in mb: ${0.000001 * messageBytes.length}');

    final nonce = sodium.randombytes.buf(sodium.crypto.secretBox.nonceBytes);
    final SecureKey key = sodium.crypto.secretBox.keygen();

    // encrypt data here
    final encryptedData = sodium.crypto.secretBox.easy(
      message: messageBytes,
      nonce: nonce,
      key: key,
    );

    Map<String, String> keys = {
      'nonce': base64Encode(nonce),
      'key': base64Encode(key.extractBytes()),
    };

    // seal the key with public key
    final encryptedKeys = sodium.crypto.box.seal(
      message: Uint8List.fromList(jsonEncode(keys).codeUnits),
      publicKey: AppCache.getUser()!.getPubKey(),
    );

    print('encrypted data in mb: ${0.000001 * encryptedData.length}');

    return EncryptedFile(encryptedData, base64Encode(encryptedKeys));
  }

  static Map<String, String> generateKeys() {
    final nonce = sodium.randombytes.buf(sodium.crypto.secretBox.nonceBytes);
    final SecureKey key = sodium.crypto.secretBox.keygen();

    Map<String, String> keys = {
      'nonce': base64Encode(nonce),
      'key': base64Encode(key.extractBytes()),
    };

    // seal the key with public key
    final encryptedKeys = sodium.crypto.box.seal(
      message: Uint8List.fromList(jsonEncode(keys).codeUnits),
      publicKey: AppCache.getUser()!.getPubKey(),
    );

    Map<String, String> base64Keys = {
      'nonce': base64Encode(nonce),
      'decryptionKey': base64Encode(encryptedKeys),
      'key': base64Encode(key.extractBytes()),
    };

    return base64Keys;
  }

  static Future<Uint8List?> encryptDataWithKeys(
      File file, Map<String, dynamic> keys) async {
    if (!file.existsSync()) return null;
    final Uint8List messageBytes = await file.readAsBytes();
    print('normal data in mb: ${0.000001 * messageBytes.length}');

    final nonce = base64Decode(keys['nonce']);
    final SecureKey key = SecureKey.fromList(sodium, base64Decode(keys['key']));

    // encrypt data here
    final encryptedData = sodium.crypto.secretBox.easy(
      message: messageBytes,
      nonce: nonce,
      key: key,
    );

    print('encrypted data in mb: ${0.000001 * encryptedData.length}');

    return encryptedData;
  }

  static Uint8List decryptData(Uint8List cipherText, String encryptedKey) {
    print('encrypted data in mb: ${0.000001 * cipherText.length}');

    // get private key
    Uint8List? key = readPrivateKey();

    // unseal the key with public and private keys
    final decryptedKeys = sodium.crypto.box.sealOpen(
      cipherText: base64Decode(encryptedKey),
      publicKey: AppCache.getUser()!.getPubKey(),
      secretKey: SecureKey.fromList(sodium, key!),
    );

    Map<String, dynamic> keys = jsonDecode(String.fromCharCodes(decryptedKeys));

    Uint8List tempNonce = keys['nonce'] is List
        ? Uint8List.fromList(keys['nonce'].cast<int>())
        : base64Decode(keys['nonce']);
    Uint8List tempKey = keys['key'] is List
        ? Uint8List.fromList(keys['key'].cast<int>())
        : base64Decode(keys['key']);
    final decryptedData = sodium.crypto.secretBox.openEasy(
      cipherText: cipherText,
      nonce: tempNonce,
      key: SecureKey.fromList(sodium, tempKey),
    );
    print('decrypted data in mb: ${0.000001 * decryptedData.length}');

    print(decryptedData.sublist(0, 10));
    return decryptedData;
  }

  static String shareData(String key, String receiverPubKey) {
    // get private key
    Uint8List? secretKey = readPrivateKey();

    // unseal the [key] with public and private keys
    final decryptedKeys = sodium.crypto.box.sealOpen(
      cipherText: base64Decode(key),
      publicKey: AppCache.getUser()!.getPubKey(),
      secretKey: SecureKey.fromList(sodium, secretKey!),
    );

    // seal the receiver public key
    final encryptedKeys = sodium.crypto.box.seal(
      message: decryptedKeys,
      publicKey: base64Decode(receiverPubKey),
    );

    return base64Encode(encryptedKeys);
  }

  static savePrivateKey(String key) {
    String filesPath = applicationDocuments.path;
    String? name = AppCache.getUser()?.id;
    final file = File('$filesPath/$name.secret');
    if (!file.existsSync()) file.createSync();

    IOSink s = file.openWrite(mode: FileMode.write);
    s.write(key);
    s.close();
  }

  static String? readKey() {
    String filesPath = applicationDocuments.path;
    String? name = AppCache.getUser()?.id;
    if (name == null) return null;
    final file = File('$filesPath/$name.secret');
    if (!file.existsSync()) return null;
    return file.readAsStringSync();
  }

  static Uint8List? readPrivateKey() {
    String? val = readKey();
    if (val == null) return null;

    return base64Decode(val);
  }
}

class EncryptedFile {
  String key;
  Uint8List file;

  EncryptedFile(this.file, this.key);
}
