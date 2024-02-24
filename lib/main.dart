import 'package:flutter/material.dart';

void main() {
  runApp(LeaderboardPage());
}

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaderboard',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LeaderboardScreen(),
    );
  }
}

class LeaderboardScreen extends StatelessWidget {
  final List<String> _players = [
    "Player 1",
    "Player 2",
    "Player 3",
    "Player 4",
    "Player 5",
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar( title: Text('Leaderboard'),),
      body: ListView.builder(
        itemCount: _players.length,
        itemBuilder: (context, index){
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(_players[index]),
            subtitle: Text('Score: ${1000 - index * 100}'),
          );
        },
      ),
    );
  }
}