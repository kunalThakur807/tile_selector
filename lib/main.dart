import 'package:flutter/material.dart';
import 'tile_service.dart';
import 'tile.dart';

void main() {
  runApp(TileSelectorApp());
}

class TileSelectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tile Selector',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TileQuestionnaireScreen(),
    );
  }
}

class TileQuestionnaireScreen extends StatefulWidget {
  @override
  _TileQuestionnaireScreenState createState() =>
      _TileQuestionnaireScreenState();
}

class _TileQuestionnaireScreenState extends State<TileQuestionnaireScreen> {
  final TextEditingController _answer1Controller = TextEditingController();
  final TextEditingController _answer2Controller = TextEditingController();
  final TextEditingController _answer3Controller = TextEditingController();
  final TileService _tileService = TileService();
  List<Tile> _suggestions = [];

  Future<void> _fetchSuggestions() async {
    final suggestions = await _tileService.getSuggestions(
      _answer1Controller.text,
      _answer2Controller.text,
      _answer3Controller.text,
    );
    setState(() {
      _suggestions = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tile Selector',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            _buildTextField(_answer1Controller, 'What kind of tile is needed?'),
            SizedBox(height: 12),
            _buildTextField(
                _answer2Controller, 'Is it for commercial use or for home?'),
            SizedBox(height: 12),
            _buildTextField(
                _answer3Controller, 'Do you have a color preference?'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchSuggestions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // replaces 'primary'
                foregroundColor: Colors.blueAccent, // replaces 'onPrimary'
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Get Suggestions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _suggestions.isNotEmpty
                  ? ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final tile = _suggestions[index];
                        return _buildTileCard(tile);
                      },
                    )
                  : Center(
                      child: Text(
                        'No suggestions available. Please answer the questions.',
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildTileCard(Tile tile) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Image.asset(tile.imageUrl, width: 60, height: 60),
        title: Text(
          tile.name,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'Usage: ${tile.usage}',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 2),
            Text(
              'Color: ${tile.color}',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
