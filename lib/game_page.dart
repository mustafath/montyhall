import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:montyhall/util/colors.dart';
import "package:provider/provider.dart";

class ClickOrInside extends ChangeNotifier {
  List myobjects = ['goat', 'goat', 'car'];
  List clickText = ['0. click', '1. click', '2. click'];
  late int firstChosen;
  late int firstGoat;
  late int secondGoat;
  late int willOpen;
  late int car;
  late int lastAnswer;
  late int toSwitch;

  bool isFirstClick = true;

  void shuffleList() {
    myobjects.shuffle();
  }

  void changeClickText(String change, int pos) {
    clickText[pos] = change;
    notifyListeners();
  }

  void game(int chosen) {
    if (isFirstClick == false) return;
    firstChosen = chosen;

    // will be moved to reset function
    clickText = ['0. click', '1. click', '2. click'];
    // will be moved to reset function

    myobjects.shuffle();

    firstGoat = myobjects.indexOf("goat");
    car = myobjects.indexOf('car');
    secondGoat = 3 - (firstGoat + car);

    if (myobjects[chosen] == 'car') {
      willOpen = firstGoat;
    } else {
      willOpen = 3 - (chosen + myobjects.indexOf('car'));
    }

    // debug prints
    print("$firstGoat $secondGoat");
    // debug prints

    changeClickText(myobjects[willOpen], willOpen);
    isFirstClick = false;
    toSwitch = 3 - (chosen + willOpen);
    print("You chose $chosen");
    print("Do you want to swtich to $toSwitch?");
  }

  void stay() {
    lastAnswer = toSwitch;

    if (lastAnswer == car) {
      print("You won");
      print(myobjects);
    } else
      print("You lost!");
    print(myobjects);
  }

  void switchTo() {
    lastAnswer = firstChosen;
    if (lastAnswer == car) {
      print("You won");
    } else
      print("You lost!");
  }
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        width: double.infinity,
        color: backgroundColor,
        child: Column(children: [Spacer(), DoorGrid(context), Spacer()]),
      ),
    );
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            for (int i = 0; i < 3; i++) CustomClickableContainer(i)
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: (() => lickOrInside.stay()),
                  child: Text(
                    "Stay",
                    style: TextStyle(color: reducedWhite),
                  )),
              TextButton(
                  onPressed: (() => lickOrInside.switchTo()),
                  child: Text(
                    "Switch",
                    style: TextStyle(color: reducedWhite),
                  ))
            ],
          )
        ],
      ),
    ),
  );
}

class CustomClickableContainer extends StatefulWidget {
  final int containerNumber;
  CustomClickableContainer(this.containerNumber);

  @override
  State<CustomClickableContainer> createState() =>
      _CustomClickableContainerState();
}

class _CustomClickableContainerState extends State<CustomClickableContainer> {
  Color containerColor = overlayBlack;

  @override
  Widget build(BuildContext context) {
    final lickOrInside = Provider.of<ClickOrInside>(context);
    return InkWell(
      onTap: (() {
        lickOrInside.game(widget.containerNumber);
        containerColor = Color.fromARGB(255, 64, 56, 24);
        setState(() {});
      }),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          alignment: Alignment.center,
          color: containerColor,
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
