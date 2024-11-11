import 'tile.dart';
import 'db_helper.dart';

class TileService {
  final DBHelper dbHelper = DBHelper();

  Future<List<Tile>> getSuggestions(
      String answer1, String answer2, String answer3) async {
    // Use a Set to store unique tiles
    Set<Tile> uniqueSuggestions = {};

    // Question 1: What kind of tile is needed?
    if (answer1.toLowerCase().contains('normal') ||
        answer1.toLowerCase().contains('regular')) {
      uniqueSuggestions.addAll(await dbHelper
          .getTilesByNames(['ABCD Tile - Black', 'ABCD Tile - White']));
    } else if (answer1.toLowerCase().contains('white')) {
      uniqueSuggestions
          .addAll(await dbHelper.getTilesByNames(['ABCD Tile - White']));
    } else if (answer1.toLowerCase().contains('black')) {
      uniqueSuggestions
          .addAll(await dbHelper.getTilesByNames(['ABCD Tile - Black']));
    }

    // Question 2: Is it for commercial use or for home?
    if (answer2.toLowerCase().contains('commercial')) {
      uniqueSuggestions
          .addAll(await dbHelper.getTilesByNames(['ABCD Tile - Black']));
    } else if (answer2.toLowerCase().contains('home')) {
      uniqueSuggestions
          .addAll(await dbHelper.getTilesByNames(['ABCD Tile - White']));
    }

    // Question 3: Do you have a color preference?
    if (answer3.toLowerCase().contains('white')) {
      uniqueSuggestions
          .addAll(await dbHelper.getTilesByNames(['ABCD Tile - White']));
    } else if (answer3.toLowerCase().contains('black')) {
      uniqueSuggestions
          .addAll(await dbHelper.getTilesByNames(['ABCD Tile - Black']));
    } else if (answer3.isNotEmpty) {
      // Add a "Coming Soon" placeholder tile if any other color preference is given
      uniqueSuggestions.add(Tile(
          name: 'Coming Soon',
          color: 'Other',
          usage: 'N/A',
          imageUrl: 'assets/coming_soon.png'));
    }

    // Convert the Set to a List to return unique values
    return uniqueSuggestions.toList();
  }
}
