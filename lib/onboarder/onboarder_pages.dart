import 'package:buddy/user/screens/user_genre.dart';
import 'package:flutter/material.dart';

class OnboarderPages {
  static const TextStyle goldcoinGreyStyle = TextStyle(
      color: Colors.grey,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  static const TextStyle goldCoinWhiteStyle = TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Product Sans");

  static const TextStyle greyStyle =
      TextStyle(fontSize: 40.0, color: Colors.grey, fontFamily: "Product Sans");
  static const TextStyle whiteStyle = TextStyle(
      fontSize: 40.0, color: Colors.white, fontFamily: "Product Sans");

  static const TextStyle boldStyle = TextStyle(
    fontSize: 50.0,
    color: Colors.black,
    fontFamily: "Product Sans",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle descriptionGreyStyle = TextStyle(
    color: Colors.grey,
    fontSize: 20.0,
    fontFamily: "Product Sans",
  );

  static const TextStyle descriptionWhiteStyle = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    fontFamily: "Product Sans",
  );

  List<Widget> getAllPages(BuildContext context) {
    return [
      Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "GoldCoin",
                    style: goldCoinWhiteStyle,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, UserGenre.routeName);
                    },
                    child: Text(
                      "Skip",
                      style: goldCoinWhiteStyle,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset("assets/images/firstImage.png"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Online",
                    style: whiteStyle,
                  ),
                  Text(
                    "Gambling",
                    style: boldStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Temporibus autem aut\n"
                    "officiis debitis aut rerum\n"
                    "necessitatibus",
                    style: descriptionWhiteStyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Container(
        color: Color(0xFF55006c),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "GoldCoin",
                    style: goldCoinWhiteStyle,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, UserGenre.routeName);
                    },
                    child: Text(
                      "Skip",
                      style: goldCoinWhiteStyle,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset("assets/images/secondImage.png"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Online",
                    style: whiteStyle,
                  ),
                  Text(
                    "Gaming",
                    style: boldStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Excepteur sint occaecat cupidatat\n"
                    "non proident, sunt in\n"
                    "culpa qui officia",
                    style: descriptionWhiteStyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Container(
        color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "GoldCoin",
                    style: goldCoinWhiteStyle,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, UserGenre.routeName);
                    },
                    child: Text(
                      "Skip",
                      style: goldCoinWhiteStyle,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset("assets/images/firstImage.png"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Online",
                    style: whiteStyle,
                  ),
                  Text(
                    "Gambling",
                    style: boldStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Temporibus autem aut\n"
                    "officiis debitis aut rerum\n"
                    "necessitatibus",
                    style: descriptionWhiteStyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ];
  }
}
