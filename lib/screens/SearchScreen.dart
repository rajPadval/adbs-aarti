import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

// Define a model class for your articles
class Article {
  final String title;
  final String lyrics;

  Article({required this.title, required this.lyrics});

  // Factory method to create Article objects from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      lyrics: json['lyrics'],
    );
  }
}

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = '';

  // List to hold loaded articles
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadArticles();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      _initSpeech();
    } else {
      // Handle the case where the user denied the permission
      setState(() {
        _speechEnabled = false;
      });
    }
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Load articles from JSON files
  void _loadArticles() async {
    try {
      // Load all JSON data into memory
      String aartiData = await DefaultAssetBundle.of(context)
          .loadString('assets/aarti_data.json');
      String bhajanData = await DefaultAssetBundle.of(context)
          .loadString('assets/bhajan_data.json');
      String jakhadiData = await DefaultAssetBundle.of(context)
          .loadString('assets/jakhadi_data.json');

      // Parse JSON strings into List of Maps
      List<dynamic> aartiJson = json.decode(aartiData);
      List<dynamic> bhajanJson = json.decode(bhajanData);
      List<dynamic> jakhadiJson = json.decode(jakhadiData);

      // Convert List of Maps into List of Article objects
      List<Article> loadedArticles = [
        ...aartiJson.map((json) => Article.fromJson(json)),
        ...bhajanJson.map((json) => Article.fromJson(json)),
        ...jakhadiJson.map((json) => Article.fromJson(json)),
      ];

      // Update state with loaded articles
      setState(() {
        articles = loadedArticles;
      });
    } catch (e) {
      print('Error loading articles: $e');
      // Handle error loading data
    }
  }

  /// Start speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _isListening = true;
    });
  }

  /// Stop speech recognition session
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  /// Speech recognition result callback
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    // Perform search based on recognized words
    _searchArticles(_lastWords.toLowerCase());
  }

  /// Search articles for a given query
  void _searchArticles(String query) {
    List<Article> searchResults = [];

    // Search through loaded articles for titles matching the query
    for (var article in articles) {
      if (article.title.toLowerCase().contains(query)) {
        searchResults.add(article);
      }
    }

    // Navigate to search results screen with searchResults
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(searchResults: searchResults),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                  _speechToText.isListening
                      ? '$_lastWords'
                      // If listening isn't active but could be tell the user
                      // how to start it, otherwise indicate that speech
                      // recognition is not yet ready or not supported on
                      // the target device
                      : _speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        child: Icon(_isListening ? Icons.mic : Icons.mic_off),
      ),
    );
  }
}

class SearchResultsScreen extends StatelessWidget {
  final List<Article> searchResults;

  const SearchResultsScreen({Key? key, required this.searchResults})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(searchResults[index].title),
            subtitle: Text(searchResults[index].lyrics),
            onTap: () {
              // Handle tapping on a search result if needed
            },
          );
        },
      ),
    );
  }
}
