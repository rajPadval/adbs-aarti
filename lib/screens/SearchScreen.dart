import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import "../constants/article.dart";
import "package:flutter/animation.dart";

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = '';
  final TextEditingController _textEditingController = TextEditingController();

  // List to hold loaded articles
  List<Article> articles = [];
  List<Article> searchResults = []; // List for search results

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadArticles();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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
    await _speechToText.listen(
        onResult: _onSpeechResult, listenFor: Duration(seconds: 10));
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
    _performSearch(_lastWords.toLowerCase());
  }

  /// Perform search based on query
  void _performSearch(String query) {
    List<Article> results = [];

    // Filter articles based on query
    for (var article in articles) {
      if (article.title.toLowerCase().contains(query)) {
        results.add(article);
      }
    }

    // Update search results
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: AppBar(
              title: const Text('Search',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              actionsIconTheme: const IconThemeData(color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _textEditingController,
              onChanged: (value) {
                // Handle text input change to update search query
                _performSearch(value.toLowerCase());
              },
              decoration: InputDecoration(
                hintText: 'Search by name',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.pinkAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  // borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.pinkAccent),
                ),
              ),
              cursorColor: Colors.pinkAccent,
              cursorOpacityAnimates: true,
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    title: Text(searchResults[index].title),
                    subtitle: Text(searchResults[index].lyrics),
                    onTap: () {
                      // Handle tapping on a search result if needed
                    },
                  ).animate().scale(),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
            alignment: Alignment.center,
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
              style: TextStyle(fontSize: 15.0, color: Colors.grey),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: _isListening ? _stopListening : _startListening,
          tooltip: 'Listen',
          backgroundColor: Colors.orange,
          // backgroundColor: Colors.transparent,
          child: Icon(
            _isListening ? Icons.mic_off : Icons.mic,
          ),
        ),
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
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: AppBar(
              title: Text('Search Results'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    title: Text(searchResults[index].title),
                    subtitle: Text(searchResults[index].lyrics),
                    onTap: () {
                      // Handle tapping on a search result if needed
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
