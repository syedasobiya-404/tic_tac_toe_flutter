import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/asset_colors.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> boxes = ["", "", "", "", "", "", "", "", ""];
  bool xTurn = true;
  int xScore = 0;
  int oScore = 0;
  String status = "";
  bool isGameOver = true;
  List<int> winnerBoxes = [];
  ConfettiController confettiController = ConfettiController();
  List<List<int>> winningPatterns = [
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [0, 1, 2],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  Timer? timer;
  int seconds = 30;

  void handleOnBoxClick(int index) {
    if (!isGameOver) {
      if (boxes[index] == "") {
        if (xTurn == true) {
          boxes[index] = "X";
        } else {
          boxes[index] = "O";
        }
        xTurn = !xTurn;
        checkWinner();
        setState(() {});
      }
    }
  }

  void handleStartGame() {
    isGameOver = false;
    boxes = ["", "", "", "", "", "", "", "", ""];
    status = "";
    winnerBoxes = [];
    seconds = 30;
    confettiController.stop();
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          if (seconds > 0) {
            seconds--;
          } else {
            status = "Game drawn";
            isGameOver = true;
          }
        });
      },
    );
  }

  void checkWinner() {
    winningPatterns.forEach(
      (element) {
        if (boxes[element[0]] != "" &&
            boxes[element[0]] == boxes[element[1]] &&
            boxes[element[0]] == boxes[element[2]]) {
          if (boxes[element[0]] == "X") {
            xScore++;
            status = "X Wins";
          } else {
            oScore++;
            status = "0 Wins";
          }
          winnerBoxes = element;
          isGameOver = true;
          timer?.cancel();
          seconds = 30;
          confettiController.play();
          return;
        }
      },
    );

    if (boxes.every((e) => e != "")) {
      status = "Game drawn";
      isGameOver = true;
      timer?.cancel();
    }
  }

  void clearScores() {
    xScore = 0;
    oScore = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AssetColors.primaryColor,
      body: ConfettiWidget(
        blastDirection: pi / 2,
        blastDirectionality: BlastDirectionality.explosive,
        numberOfParticles: 120,
        // colors: [Colors.pink, Colors.black, Colors.grey],
        gravity: 0.5,
        confettiController: confettiController,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section Start
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Player X",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          xScore.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      children: [
                        Text(
                          "Player O",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          oScore.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    )
                  ],
                ),
                Spacer(
                  flex: 1,
                ),
                Text(
                  status,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // Header Section End

                // Game Grid Section Start
                SizedBox(
                  height: 430,
                  child: GridView.builder(
                    itemCount: boxes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          handleOnBoxClick(index);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              6,
                            ),
                            color: winnerBoxes.contains(index)
                                ? AssetColors.accentColor
                                : AssetColors.secondaryColor,
                          ),
                          child: Text(
                            boxes[index],
                            style: TextStyle(
                              fontSize: 76,
                              color: AssetColors.primaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Game Grid Section End
                Spacer(
                  flex: 1,
                ),
                // Footer Section Start

                isGameOver == true
                    ? Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black,
                            )),
                            onPressed: () {
                              handleStartGame();
                            },
                            child: Text(
                              "Start",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black,
                            )),
                            onPressed: () {
                              clearScores();
                            },
                            child: Text(
                              "Reset Scores",
                            ),
                          )
                        ],
                      )
                    : SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: seconds / 30,
                              strokeWidth: 8,
                              valueColor: AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                              backgroundColor: AssetColors.accentColor,
                            ),
                            Center(
                              child: Text(
                                seconds.toString(),
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                // Footer Section End
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
