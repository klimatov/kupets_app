import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/wiki_summary.dart';

class WikiRemoteDataSource {
  WikiRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<WikiSummary?> fetchCraftBeerSummary() async {
    final response = await _client.get(
      Uri.parse(
        'https://ru.wikipedia.org/api/rest_v1/page/summary/%D0%9A%D1%80%D0%B0%D1%84%D1%82%D0%BE%D0%B2%D0%BE%D0%B5_%D0%BF%D0%B8%D0%B2%D0%BE',
      ),
    );
    if (response.statusCode != 200) return null;
    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return WikiSummary.fromJson(json);
  }
}
