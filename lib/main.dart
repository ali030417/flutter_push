import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    String millisecondText = '';
    GameState gameState = GameState.readyToStart;

    Timer?waitingTimer;
    Timer?stoppeableTimer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282E3D),
      body: Stack(
        children: [
          const Align(
              alignment: Alignment(0, -0.85),
              child: Text(
                'Test your\n reaction speed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 38,
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: const Color(0xFF6D6D6D),
              child: SizedBox(
                height: 160,
                width: 300,
                child: Center(
                  child: Text(
                    millisecondText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.85),
            child: GestureDetector(
              onTap: () => setState((){
                switch (gameState){
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    millisecondText = '';
                    _startWaitingTImer();
                  break;
                  case GameState.waiting:
                    gameState = GameState.canBeStopped;
                  break;
                  case GameState.canBeStopped:
                    gameState = GameState.readyToStart;
                    stoppeableTimer?.cancel();
                }
              }),
              child: ColoredBox(
                color: _getButtonColor(),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Text(
                      _getButtonText(),
                      style: const TextStyle(
                        fontSize: 38,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (gameState){
      case GameState.readyToStart:
        return 'START';
      case GameState.waiting:
        return 'WAIT';
      case GameState.canBeStopped:
        return 'STOP';
    }
  }

  Color _getButtonColor() {
    switch (gameState){
      case GameState.readyToStart:
        return const Color(0xFF40CA88);
      case GameState.waiting:
        return const Color(0xFFE0982D);
      case GameState.canBeStopped:
        return const Color(0xffe02d47);
    }
  }

  void _startWaitingTImer() {
    final int randomMilliseconds = Random().nextInt(4000)+ 1000;
    Timer(Duration(milliseconds: randomMilliseconds), (){
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer(){
    stoppeableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondText = '${timer.tick*16} ms';
      });
     });
  }

  @override
  void dispose(){
    waitingTimer?.cancel();
    stoppeableTimer?.cancel();
    super.dispose();
  }
}

enum GameState {readyToStart, waiting, canBeStopped}
