import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AssetImage circle = const AssetImage('assets/images/circle.png');
  AssetImage lucky = const AssetImage('assets/images/rupee.jpg');
  AssetImage unLucky = const AssetImage('assets/images/sad_emoji.png');
  late List<String> itemArray;
  late int luckyNumber;
  int limit = 0;

  @override
  void initState() {
    super.initState();
    itemArray = List<String>.generate(25, (index) => "empty");
    generateRandomNumber();
  }

  generateRandomNumber() {
    int randomNumber = Random().nextInt(25);
    setState(() {
      luckyNumber = randomNumber;
    });
  }

  AssetImage getImage(int index) {
    String currentState = itemArray[index];
    switch (currentState) {
      case "lucky":
        return lucky;
      case "unLucky":
        return unLucky;
    }
    return circle;
  }

  playGame(int index) {
    if (limit < 5) {
      limit++;
      if (luckyNumber == index) {
        setState(() {
          itemArray[index] = "lucky";
          _showToast(context, "You are winner!!!");
        });
      } else {
        setState(() {
          itemArray[index] = "unLucky";
        });
      }
    } else {
      _showToast(context, "Only 5 attempts are allowed");
    }
  }

  showAll() {
    setState(() {
      itemArray = List<String>.filled(25, "unLucky");
      itemArray[luckyNumber] = "lucky";
    });
  }

  resetGame() {
    limit = 0;
    setState(() {
      itemArray = List<String>.filled(25, "empty");
    });
    generateRandomNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scratch and Win App')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: itemArray.length,
              itemBuilder: (context, i) => SizedBox(
                width: 50.0,
                height: 50.0,
                child: MaterialButton(
                  onPressed: () => playGame(i),
                  child: Image(
                    image: getImage(i),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(5.0),
            child: ElevatedButton(
              onPressed: () => showAll(),
              child: const Text("Show All"),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(5.0),
            child: ElevatedButton(
              onPressed: () => resetGame(),
              child: const Text("Reset"),
            ),
          )
        ],
      ),
    );
  }
}

void _showToast(BuildContext context, String msg) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(msg),
      action: SnackBarAction(
          label: 'HIDE', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}
