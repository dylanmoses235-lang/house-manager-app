import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class CloudSyncService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static bool _isEnabled = false;
  static DateTime? _lastSync;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool('cloud_sync_enabled') ?? false;
    final lastSyncMs = prefs.getInt('last_sync_timestamp');
    if (lastSyncMs != null) {
      _lastSync = DateTime.fromMillisecondsSinceEpoch(lastSyncMs);
    }
  }

  static Future<bool> enableSync() async {
    try {
      // Sign in anonymously for basic cloud storage
      final userCredential = await _auth.signInAnonymously();
      if (userCredential.user != null) {
        _isEnabled = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('cloud_sync_enabled', true);
        return true;
      }
      return false;
    } catch (e) {
      print('Error enabling sync: $e');
      return false;
    }
  }

  static Future<void> disableSync() async {
    _isEnabled = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cloud_sync_enabled', false);
  }

  static bool get isEnabled => _isEnabled;
  static DateTime? get lastSync => _lastSync;

  // Upload data to cloud
  static Future<void> syncData(String collection, Map<String, dynamic> data) async {
    if (!_isEnabled || _auth.currentUser == null) return;

    try {
      final userId = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .doc(data['id'])
          .set({
        ...data,
        'lastModified': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _lastSync = DateTime.now();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_sync_timestamp', _lastSync!.millisecondsSinceEpoch);
    } catch (e) {
      print('Error syncing data: $e');
    }
  }

  // Download data from cloud
  static Future<List<Map<String, dynamic>>> fetchData(String collection) async {
    if (!_isEnabled || _auth.currentUser == null) return [];

    try {
      final userId = _auth.currentUser!.uid;
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  // Upload file (photo, receipt, etc.)
  static Future<String?> uploadFile(String path, String fileName) async {
    if (!_isEnabled || _auth.currentUser == null) return null;

    try {
      final userId = _auth.currentUser!.uid;
      final file = File(path);
      final ref = _storage.ref().child('users/$userId/files/$fileName');
      
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  // Download file
  static Future<String?> downloadFile(String cloudUrl, String localPath) async {
    if (!_isEnabled || _auth.currentUser == null) return null;

    try {
      final ref = _storage.refFromURL(cloudUrl);
      final file = File(localPath);
      await ref.writeToFile(file);
      return localPath;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  // Backup all data
  static Future<void> createBackup(Map<String, dynamic> allData) async {
    if (!_isEnabled || _auth.currentUser == null) return;

    try {
      final userId = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('backups')
          .doc(DateTime.now().toIso8601String())
          .set({
        'data': allData,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _lastSync = DateTime.now();
    } catch (e) {
      print('Error creating backup: $e');
    }
  }

  // Restore from backup
  static Future<Map<String, dynamic>?> restoreLatestBackup() async {
    if (!_isEnabled || _auth.currentUser == null) return null;

    try {
      final userId = _auth.currentUser!.uid;
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('backups')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return snapshot.docs.first.data()['data'] as Map<String, dynamic>?;
    } catch (e) {
      print('Error restoring backup: $e');
      return null;
    }
  }

  // Get available backups
  static Future<List<Map<String, dynamic>>> getBackupHistory() async {
    if (!_isEnabled || _auth.currentUser == null) return [];

    try {
      final userId = _auth.currentUser!.uid;
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('backups')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'timestamp': (doc.data()['timestamp'] as Timestamp?)?.toDate(),
        };
      }).toList();
    } catch (e) {
      print('Error getting backup history: $e');
      return [];
    }
  }
}
