import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:montyhall/util/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClickOrInside extends ChangeNotifier {
  List<ScatterSpot> scatters = [];

  void addScatter(String action) {
    double stayWinRate = (scores["stay"]["win"] /
            (scores["stay"]["win"] + scores["stay"]["lose"])) *
        100;

    double switchWinRate = (scores["switch"]["win"] /
            (scores["switch"]["win"] + scores["switch"]["lose"])) *
        100;

    double stayLoseRate = (scores["stay"]["lose"] /
            (scores["stay"]["win"] + scores["stay"]["lose"])) *
        100;

    double switchLoseRate = (scores["switch"]["lose"] /
            (scores["switch"]["win"] + scores["switch"]["lose"])) *
        100;

    int toplam_stay = scores['stay']['win'] + scores['stay']['lose'];
    int toplam_switch = scores['switch']['win'] + scores['switch']['lose'];

    double x;
    double y;
    Color color = Colors.black;

    if (action == "Stay") {
      color = Colors.green;
      x = toplam_stay + 0;
      y = stayWinRate;
    } else {
      color = Colors.yellow;
      x = toplam_switch + 0;
      y = switchWinRate;
    }

    scatters.add(ScatterSpot(x, y, color: color, radius: 2));
    notifyListeners();
  }

  String signifierText = "Choose a door";
  bool stop = false;

  Future<void> stopFunction() async {
    stop = true;
    notifyListeners();
    print("*" * 100);
    print("clicked");
    print("*" * 100);
  }

  void changeSignifierText(String change) {
    signifierText = change;
    notifyListeners();
  }

  Map scores = {
    'stay': {'win': 0, 'lose': 0},
    'switch': {'win': 0, 'lose': 0}
  };

  List<Color> colorOfContainers = [overlayBlack, overlayBlack, overlayBlack];

  void changeColor(int id, Color newcolor) {
    colorOfContainers[id] = newcolor;
  }

  List myobjects = ['goat', 'goat', 'car'];
  List clickText = ['Door 0', 'Door 1', 'Door 2'];

  late int firstChosen;
  late int firstGoat;
  late int secondGoat;
  late int willOpen;
  late int car;
  late int lastAnswer;
  late int toSwitch;

  bool isFirstClick = true;
  bool stayOrSwitchClick = true;

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
    toSwitch = 3 - (chosen + willOpen);

    changeClickText(myobjects[willOpen], willOpen);
    changeClickText("Stay", chosen);
    changeClickText("Switch", toSwitch);
    changeColor(willOpen, Colors.red);
    isFirstClick = false;

    print("You chose $chosen");
    print("Do you want to swtich to $toSwitch?");
    changeSignifierText("Do you want to swtich to ${toSwitch + 1}?");
  }

  void stay() {
    if (stayOrSwitchClick == false) return;
    if (isFirstClick == true) return;

    lastAnswer = firstChosen;

    if (lastAnswer == car) {
      print("You won");
      changeColor(lastAnswer, Colors.green);
      changeColor(toSwitch, Colors.red);
      scores['stay']['win'] += 1;
      changeSignifierText("You won!");
    } else {
      changeSignifierText("You lost...");
      changeColor(lastAnswer, Colors.red);
      changeColor(car, Colors.green);
      scores['stay']['lose'] += 1;
    }
    for (int i = 0; i < 3; i++) {
      changeClickText(myobjects[i], i);
    }
    stayOrSwitchClick = false;
    addScatter("Stay");
  }

  void switchTo() {
    if (stayOrSwitchClick == false) return;
    if (isFirstClick == true) return;
    lastAnswer = toSwitch;
    if (lastAnswer == car) {
      changeSignifierText("You won!");
      changeColor(firstChosen, Colors.red);
      changeColor(lastAnswer, Colors.green);

      scores['switch']['win'] += 1;
    } else {
      changeSignifierText("You lost...");
      changeColor(lastAnswer, Colors.red);
      changeColor(car, Colors.green);
      scores['switch']['lose'] += 1;
      for (int i = 0; i < 3; i++) {
        changeClickText(myobjects[i], i);
      }
    }
    stayOrSwitchClick = false;
    addScatter("Switch");
  }

  void reset() {
    myobjects = ['goat', 'goat', 'car'];
    clickText = ['Door 0', 'Door 1', 'Door 2'];
    colorOfContainers = [overlayBlack, overlayBlack, overlayBlack];
    int firstChosen;
    int firstGoat;
    int secondGoat;
    int willOpen;
    int car;
    int lastAnswer;
    int toSwitch;

    isFirstClick = true;
    signifierText = "Choose a door";
    stayOrSwitchClick = true;
    notifyListeners();
  }
}
