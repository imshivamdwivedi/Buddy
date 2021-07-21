import 'package:buddy/constants.dart';
import 'package:buddy/user/models/category_class.dart';
import 'package:buddy/user/models/user_genre_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-genre-screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        foregroundColor: Colors.black87,
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Search Genre Here!',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: TypeAheadField<Category?>(
                  debounceDuration: Duration(microseconds: 500),
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                      focusColor: Colors.black87,
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search User name',
                    ),
                  ),
                  suggestionsCallback: CategoryAPI.getUserSuggestion,
                  itemBuilder: (context, Category? suggestions) {
                    final category = suggestions!;
                    return ListTile(
                      onTap: () {
                        Provider.of<UserGenreProvider>(context, listen: false)
                            .addGenre(category);
                        Navigator.of(context).pop('Genre added successfully!');
                      },
                      title: Text(category.name),
                    );
                  },
                  noItemsFoundBuilder: (context) => Container(
                    height: 100,
                    child: Center(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No such genre found",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            if (Provider.of<UserGenreProvider>(context)
                                    .getQuery
                                    .length >
                                2)
                              TextButton(
                                onPressed: () {
                                  String str = Provider.of<UserGenreProvider>(
                                          context,
                                          listen: false)
                                      .getQuery;
                                  String string = str.replaceAll(
                                      new RegExp(r'(?:_|[^\w\s])+'), '');
                                  string =
                                      string.replaceAll(' ', '').toLowerCase();
                                  final newGenre =
                                      Category(name: str, id: string, count: 1);
                                  Provider.of<UserGenreProvider>(context,
                                          listen: false)
                                      .createGenre(newGenre);
                                  Navigator.of(context)
                                      .pop('New genre created successfully!');
                                },
                                child: Text(
                                  "Create One",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onSuggestionSelected: (Category? suggestions) {
                    final category = suggestions;

                    Text(category!.name);
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              new Image.asset(
                "assets/images/Search.gif",
                height: 200.0,
                width: 200.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
