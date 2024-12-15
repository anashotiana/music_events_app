import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResultsScreen extends StatefulWidget {
  final String location;
  final DateTime date;

  const ResultsScreen({Key? key, required this.location, required this.date})
      : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late Future<List> _events;

  Future<List> fetchEvents() async {
    final String apiKey = 'tJq8cVjvGZCobB7xkFs2giDoGOU70nMU';
    final String formattedDate = widget.date.toIso8601String().split('T')[0];
    final String url =
        'https://app.ticketmaster.com/discovery/v2/events.json?apikey=$apiKey&city=${widget.location}&startDateTime=${formattedDate}T00:00:00Z';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['_embedded']?['events'] ?? [];
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  void initState() {
    super.initState();
    _events = fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Results')),
      body: FutureBuilder<List>(
        future: _events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final event = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(event['name'] ?? 'No Title'),
                    subtitle: Text(event['dates']['start']['localDate'] ?? ''),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
