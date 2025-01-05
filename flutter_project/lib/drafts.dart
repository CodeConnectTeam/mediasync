import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'authprovider.dart';
import 'login.dart';
import 'sidebar.dart';

class DraftPage extends StatefulWidget {
  @override
  _DraftPageState createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final String? token = Provider.of<AuthProvider>(context).token;

    // Kullanıcı oturum açmamışsa LoginPage'e yönlendirilir
    if (token == null) {
      return const LoginPage();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Row(
        children: [
          SideBar(selectedMenu: "Drafts"),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader("Twitter Drafts"),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: fetchDrafts(token, platform: 'twitter'),
                            builder: (context, snapshot) {
                              return _buildDraftList(context, snapshot, token,
                                  isTwitter: true);
                            },
                          ),
                          const SizedBox(height: 30),
                          _buildSectionHeader("Instagram Drafts"),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: fetchDrafts(token, platform: 'instagram'),
                            builder: (context, snapshot) {
                              return _buildDraftList(context, snapshot, token,
                                  isTwitter: false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sayfa başlığını oluşturan metod
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        'Drafts',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }

  // Bölüm başlıklarını oluşturan metod
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Taslak listesini oluşturan metod
  Widget _buildDraftList(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot, String token,
      {required bool isTwitter}) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(
        child: Text(
          'Failed to load drafts.\nError: ${snapshot.error}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
        child: Text('No drafts available.', style: TextStyle(fontSize: 18)),
      );
    }

    final drafts = snapshot.data!;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: drafts.length,
      itemBuilder: (context, index) {
        final draft = drafts[index];
        return isTwitter
            ? _buildTwitterDraftItem(context, draft, token)
            : _buildInstagramDraftItem(context, draft, token);
      },
    );
  }

  // Twitter taslak öğesi
  Widget _buildTwitterDraftItem(
      BuildContext context, Map<String, dynamic> draft, String token) {
    return ListTile(
      title: Text(draft['tweetText'] ?? 'No text available',
          style: const TextStyle(fontSize: 16)),
      subtitle: Text('Created At: ${_formatDate(draft['createdAt'])}',
          style: const TextStyle(color: Colors.grey)),
      trailing:
          _buildActionButtons(context, token, draft['id'], isTwitter: true),
    );
  }

  // Instagram taslak öğesi
  Widget _buildInstagramDraftItem(
      BuildContext context, Map<String, dynamic> draft, String token) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: draft['imageUrl'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(draft['imageUrl'],
                    width: 40, height: 40, fit: BoxFit.cover),
              )
            : const Icon(Icons.image, size: 40, color: Colors.grey),
        title: Text(draft['caption'] ?? 'No caption available',
            style: const TextStyle(fontSize: 16)),
        subtitle: Text('Status: ${draft['status'] ?? 'Unknown'}',
            style: const TextStyle(color: Colors.grey)),
        trailing:
            _buildActionButtons(context, token, draft['id'], isTwitter: false),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String token, int id,
      {required bool isTwitter}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () =>
              _deleteDraft(context, token, id, isTwitter: isTwitter),
        ),
        IconButton(
          icon: const Icon(Icons.publish, color: Colors.green),
          onPressed: () =>
              _publishDraft(context, token, id, isTwitter: isTwitter),
        ),
        IconButton(
          icon: const Icon(Icons.schedule, color: Colors.blue),
          onPressed: () => _selectDate(context, token, id, isTwitter),
        ),
      ],
    );
  }

  Future<void> _selectDate(
      BuildContext context, String token, int id, bool isTwitter) async {
    // Show the date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Show the time picker after selecting the date
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            DateTime.now()), // Start with the current time
      );

      if (pickedTime != null) {
        // Combine the selected date and time into a single DateTime object
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Schedule the draft with the combined date and time
        _scheduleDraft(context, token, id, isTwitter, selectedDateTime);
      }
    }
  }

  Future<void> _scheduleDraft(BuildContext context, String token, int id,
      bool isTwitter, DateTime selectedDate) async {
    final url = Uri.parse('http://13.60.226.247:8080/api/schedule');

    // Convert selected date and time to the desired format "yyyy-MM-ddTHH:mm:ss"
    final formattedDate =
        "${selectedDate.toIso8601String().split('T')[0]}T${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}:00";

    // Platform value dynamically adjusted
    final platform = isTwitter ? 'TWITTER' : 'INSTAGRAM';

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'post_id': id,
          'scheduled_time': formattedDate, // Use the selected time
          'is_active': true,
          'platform': platform,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Draft scheduled successfully!')),
        );
      } else {
        throw Exception(
            'Failed to schedule draft. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Taslakları yayımlama metodu
  Future<void> _publishDraft(BuildContext context, String token, int id,
      {required bool isTwitter}) async {
    final platform = isTwitter ? 'TWITTER' : 'INSTAGRAM';
    final url =
        Uri.parse('http://13.60.226.247:8080/api/posts/$platform/publish/$id');

    try {
      final response =
          await http.post(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Draft published successfully!')));
      } else {
        throw Exception(
            'Failed to publish draft. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Taslakları silme metodu
  Future<void> _deleteDraft(BuildContext context, String token, int id,
      {required bool isTwitter}) async {
    final platform = isTwitter ? 'TWITTER' : 'INSTAGRAM';
    final url = Uri.parse('http://13.60.226.247:8080/api/posts/$platform/$id');

    try {
      final response =
          await http.delete(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Draft deleted successfully!')));
      } else {
        throw Exception(
            'Failed to delete draft. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Tarih biçimlendirme metodu
  String _formatDate(dynamic createdAt) {
    try {
      if (createdAt is String) {
        final date = DateTime.parse(createdAt).toLocal();
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      }
      return 'Invalid date format';
    } catch (e) {
      return 'Error formatting date: $e';
    }
  }

  // Taslakları getiren metod
  Future<List<Map<String, dynamic>>> fetchDrafts(String token,
      {required String platform}) async {
    final url =
        Uri.parse('http://13.60.226.247:8080/api/posts/$platform/drafts');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
            'Failed to load drafts. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching drafts: $e');
    }
  }
}
