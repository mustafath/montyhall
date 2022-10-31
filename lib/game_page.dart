import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:montyhall/util/colors.dart';
import "package:provider/provider.dart";

import 'click.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MyBody(),
    );
  }
}

class MyBody extends StatelessWidget {
  const MyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        color: backgroundColor,
        child: Column(children: [
          Spacer(),
          Spacer(),
          DoorGrid(context),
          Spacer(),
          Repeat(context),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stats(context),
              InteractiveViewer(child: PlotChart(context)),
            ],
          ),
          Spacer(),
        ]),
      ),
    );
  }

  Widget PlotChart(BuildContext context) {
    final lickOrInside = Provider.of<ClickOrInside>(
      context,
    );

    return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.all(10),
          width: 170,
          height: 170,
          color: containerColor,
          child: ScatterChart(
            swapAnimationCurve: Curves.easeIn,
            ScatterChartData(
                backgroundColor: overlayBlack,
                titlesData: FlTitlesData(show: false),
                minY: 0,
                minX: 1,
                maxY: 100,
                borderData: FlBorderData(show: false),
                scatterSpots: [...lickOrInside.scatters]),
          ),
        ));
  }

  Widget Repeat(BuildContext context) {
    String? action;
    TextEditingController times = TextEditingController();
    final lickOrInside = Provider.of<ClickOrInside>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 390,
        height: 70,
        color: containerColor,
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 20, end: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 40,
                width: 100,
                color: overlayBlack,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton(
                          hint: const Text("Action"),
                          items: [
                            DropdownMenuItem(
                              child: Text("Switch"),
                              value: "Switch",
                            ),
                            DropdownMenuItem(
                              child: Text("Stay"),
                              value: "Stay",
                            )
                          ],
                          onChanged: ((value) {
                            action = value;
                            print(action);
                          })),
                    ),
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                alignment: Alignment.center,
                color: overlayBlack,
                width: 82,
                height: 40,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: TextField(
                      controller: times,
                      decoration: InputDecoration(
                          hintText: "times", border: InputBorder.none)),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                width: 82,
                height: 40,
                color: reducedWhite,
                child: TextButton(
                  child: Text(
                    "REPEAT",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    if (times.text == "") return;
                    repeat(context,
                        times: int.parse(times.text), action: action ?? "Stay");
                  },
                ),
              ),
            ),
            TextButton(
              child: Text(
                "STOP",
                style: TextStyle(color: reducedWhite),
              ),
              onPressed: () {
                lickOrInside.stopFunction();
              },
            )
          ]),
        ),
      ),
    );
  }

  Widget Stats(BuildContext context) {
    final lickOrInside = Provider.of<ClickOrInside>(
      context,
    );

    print(lickOrInside.scores);
    double stayWinRate = 0;
    double switchWinRate = 0;
    double stayLoseRate = 0;
    double switchLoseRate = 0;
    if (lickOrInside.scores["stay"]["win"] != 0) {
      stayWinRate = (lickOrInside.scores["stay"]["win"] /
              (lickOrInside.scores["stay"]["win"] +
                  lickOrInside.scores["stay"]["lose"])) *
          100;
    }
    if (lickOrInside.scores["switch"]["win"] != 0) {
      switchWinRate = (lickOrInside.scores["switch"]["win"] /
              (lickOrInside.scores["switch"]["win"] +
                  lickOrInside.scores["switch"]["lose"])) *
          100;
    }
    if (lickOrInside.scores["stay"]["lose"] != 0) {
      stayLoseRate = (lickOrInside.scores["stay"]["lose"] /
              (lickOrInside.scores["stay"]["win"] +
                  lickOrInside.scores["stay"]["lose"])) *
          100;
    }
    if (lickOrInside.scores["switch"]["lose"] != 0) {
      switchLoseRate = (lickOrInside.scores["switch"]["lose"] /
              (lickOrInside.scores["switch"]["win"] +
                  lickOrInside.scores["switch"]["lose"])) *
          100;
    }

    String formattedStayWin =
        "${lickOrInside.scores["stay"]["win"]}\n(%${stayWinRate.truncate().toString()})";
    String formattedStayLose =
        "${lickOrInside.scores["stay"]["lose"]}\n(%${stayLoseRate.truncate().toString()})";
    String formattedSwitchWin =
        "${lickOrInside.scores["switch"]["win"]}\n(%${switchWinRate.truncate().toString()})";
    String formattedSwitchLose =
        "${lickOrInside.scores["switch"]["lose"]}\n(%${switchLoseRate.truncate().toString()})";

    return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
            width: 170,
            height: 170,
            color: containerColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomGridContainer(null),
                      CustomGridContainer("Stay"),
                      CustomGridContainer("Switch")
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomGridContainer("Win"),
                      CustomGridContainer(formattedStayWin),
                      CustomGridContainer(formattedSwitchWin)
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomGridContainer("Lose"),
                      CustomGridContainer(formattedStayLose),
                      CustomGridContainer(formattedSwitchLose)
                    ]),
              ],
            )));
  }
}

Widget CustomGridContainer(String? text) {
  text = text ?? "";
  return Container(
    alignment: Alignment.center,

    // color: Color.fromARGB(255, 144, 144, 144),
    child: Text(text),
  );
}

Future<void> repeat(BuildContext context,
    {int times = 0, String action = ""}) async {
  if (action == "") return;

  final lickOrInside = Provider.of<ClickOrInside>(context, listen: false);
  lickOrInside.stop = false;

  for (int i = 0; i < times; i++) {
    List ints = [0, 1, 2];
    ints.shuffle();

    if (lickOrInside.stop == true) break;
    await Future.delayed(Duration(milliseconds: 1));
    lickOrInside.game(ints[0]);
    lickOrInside.changeColor(ints[0], Color.fromARGB(255, 72, 132, 144));
    await Future.delayed(Duration(milliseconds: 1));
    if (action == "Stay") lickOrInside.stay();
    if (action == "Switch") lickOrInside.switchTo();
    await Future.delayed(Duration(milliseconds: 1));
    lickOrInside.reset();
  }
}

Widget DoorGrid(BuildContext context) {
  final lickOrInside = Provider.of<ClickOrInside>(context);
  return ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: Container(
      width: 360,
      height: 310,
      color: containerColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(lickOrInside.signifierText,
              textAlign: TextAlign.center,
              style: TextStyle(color: reducedWhite, fontSize: 20)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            for (int i = 0; i < 3; i++) CustomClickableContainer(i)
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButtonClean(action: lickOrInside.stay, textDisplay: 'Stay'),
              TextButtonClean(
                  action: lickOrInside.switchTo, textDisplay: 'Switch'),
              TextButtonClean(
                  action: lickOrInside.reset, textDisplay: 'Reset Game'),
            ],
          )
        ],
      ),
    ),
  );
}

class TextButtonClean extends StatelessWidget {
  const TextButtonClean({Key? key, required this.action, this.textDisplay = ''})
      : super(key: key);

  final Function action;
  final String textDisplay;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (() => action()),
        child: Text(
          textDisplay,
          style: TextStyle(color: reducedWhite),
        ));
  }
}

class CustomClickableContainer extends StatefulWidget {
  final int containerNumber;
  CustomClickableContainer(this.containerNumber);

  @override
  State<CustomClickableContainer> createState() =>
      _CustomClickableContainerState();
}

class _CustomClickableContainerState extends State<CustomClickableContainer> {
  @override
  Widget build(BuildContext context) {
    final lickOrInside = Provider.of<ClickOrInside>(context);
    return InkWell(
      onTap: (() {
        lickOrInside.game(widget.containerNumber);
        lickOrInside.changeColor(
            widget.containerNumber, Color.fromARGB(255, 72, 132, 144));
      }),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          alignment: Alignment.center,
          color: lickOrInside.colorOfContainers[widget.containerNumber],
          width: 90,
          height: 90,
          child: Text(
            lickOrInside.clickText[widget.containerNumber],
            style: TextStyle(color: reducedWhite),
          ),
        ),
      ),
    );
  }
}
