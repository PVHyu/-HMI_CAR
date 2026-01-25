import 'dart:convert';
import 'package:flutter/services.dart';
import '../../phone_app/models/contact.dart';
import '../../phone_app/models/call_log.dart';

class MockDataService {
  static Future<Map<String, dynamic>> loadMockData() async {
    final String response =
        await rootBundle.loadString('assets/mock_data.json');
    return json.decode(response) as Map<String, dynamic>;
  }

  static Future<List<Contact>> loadContacts() async {
    final data = await loadMockData();
    final contactsJson = data['contacts'] as List;
    return contactsJson.map((json) => Contact.fromJson(json)).toList();
  }

  static Future<List<CallLog>> loadCallLogs() async {
    final data = await loadMockData();
    final logsJson = data['call_logs'] as List;
    return logsJson.map((json) => CallLog.fromJson(json)).toList();
  }

  static Future<int> getRingTimeout() async {
    final data = await loadMockData();
    final settings = data['call_settings'] as Map<String, dynamic>;
    return settings['ring_timeout_seconds'] as int;
  }

  static Future<List<String>> getUnreachableNumbers() async {
    final data = await loadMockData();
    final numbers = data['unreachable_numbers'] as List?;
    return numbers?.map((e) => e.toString()).toList() ?? [];
  }
}
