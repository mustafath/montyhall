import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:montyhall/game_page.dart';
import 'package:montyhall/util/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardScreenScaffold(),
    );
  }
}

class OnBoardScreenScaffold extends StatefulWidget {
  const OnBoardScreenScaffold({super.key});

  @override
  State<OnBoardScreenScaffold> createState() => _OnBoardScreenScaffoldState();
}

class _OnBoardScreenScaffoldState extends State<OnBoardScreenScaffold> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  PageController _pageController = PageController(initialPage: 0);
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Container(
                  width: 400,
                  height: 600,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (value) {
                      pageIndex = value;
                      setState(() {});
                    },
                    children: [...introductionPages],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(),
                  SizedBox(
                    width: 90,
                  ),
                  Row(
                    children: [
                      ...List.generate(introductionPages.length, (index) {
                        return Indicators(
                          isSelected: index == pageIndex,
                        );
                      })
                    ],
                  ),
                  Spacer(),
                  SkipAndNextButton(
                      pageController: _pageController, pageIndex: pageIndex),
                ],
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

class Indicators extends StatelessWidget {
  Indicators({
    this.isSelected = false,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: AnimatedContainer(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: reducedWhite,
        ),
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.all(3),
        width: isSelected ? 12 : 4,
        height: isSelected ? 12 : 4,
      ),
    );
  }
}

class SkipAndNextButton extends StatefulWidget {
  final PageController pageController;
  final int pageIndex;

  SkipAndNextButton({required this.pageController, required this.pageIndex});

  @override
  State<SkipAndNextButton> createState() => _SkipAndNextButtonState();
}

class _SkipAndNextButtonState extends State<SkipAndNextButton> {
  Future<void> setOnboardScreenDone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isDone", true);
    print(preferences.getBool("isDone"));
  }

  var next_or_done = Icons.arrow_right;
  var buttonText = "Next";

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: Container(
        width: 90,
        color: reducedWhite,
        child: TextButton(
            onPressed: (() {
              widget.pageIndex == introductionPages.length - 1
                  ? Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: ((context) => GamePage())))
                  : widget.pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
              setState(() {
                if (widget.pageIndex == introductionPages.length - 2) {
                  next_or_done = Icons.done;
                  buttonText = "Done";
                  setOnboardScreenDone();
                }
              });
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  buttonText,
                  style: TextStyle(color: Colors.black),
                ),
                Icon(
                  next_or_done,
                  color: Colors.black,
                )
              ],
            )),
      ),
    );
  }
}

List introductionPages = [
  PageDesing(
      imageURL:
          "https://ds055uzetaobb.cloudfront.net/brioche/uploads/w9JKNMjyTP-doors-1767564_1280-1024x546.png?width=2400",
      text: "İsmini ABD televizyonlarında 1963-1976 yılları arasında "
          "yayınlanan Let’s Make a Deal (Bir Anlaşma Yapalım) isimli yarışma programının sunucusundan alan Monty Hall problemi aslında basit bir olasılık sorusuydu."),
  PageDesing(
    imageURL:
        "https://bilimgenc.tubitak.gov.tr/sites/default/files/monty-hall-problemi-2.jpg",
    text:
        "Yarışmadaki üç kapıdan birinin arkasında son model bir araba, diğer ikisinin arkasında ise keçi vardır. Yarışmacıların amacı, arabanın bulunduğu kapıyı doğru tahmin etmek ve arabayı kazanmaktır. "
        "Arabanın hangi kapının arkasında olduğunu bilen sunucu Monty Hall, yarışmacıdan bir kapı seçmesini ister. Yarışmacının üç kapı arasından yaptığı bu seçim ile arabayı kazanma olasılığı 1/3 iken kazanamama olasılığı 2/3’tür. Yarışmacının seçtiği kapı açılmadan önce Monty Hall, arkasında keçi olan bir kapıyı açar. (Yarışmacı hangi kapıyı seçerse seçsin, geriye kalan kapılardan en az birinin arkasında keçi bulunmak zorundadır.) Bu durumda kapalı iki kapı kalır: yarışmacının seçtiği kapı ile seçmediği diğer kapı.",
  ),
  PageDesing(
      text:
          "Monty Hall, yarışmacının seçtiği kapıyı açmadan önce yarışmanın heyecanını artırmak ister ve yarışmacıya yeni bir seçim yapma hakkı verir. Yarışmacı ya ilk seçtiği kapı ile devam eder ya da fikrini değiştirip diğer kapıyı seçer. Son olarak seçilen kapı açılır ve yarışmacının arabayı kazanıp kazanamadığı belli olur."
          "Yarışmayı kazanmak biraz şans işidir. Çünkü arabanın kesin olarak kazanılacağı bir durum söz konusu değil. Fakat kazanma ihtimali yüksek tercihler yapmak yarışmacının şansını artıracağı için daha akıllıca olacaktır."),
  PageDesing(
      text:
          "Peki sizce yarışmacı son iki kapı kaldığında seçimini değiştirmeli mi yoksa ilk seçtiği kapıda ısrarcı mı olmalı? Başka bir deyişle, son aşamada ilk seçilen kapıyı değiştirmek araba kazanma ihtimalini artırır mı, değiştirmez mi yoksa azaltır mı?"
          "Eğer cevabınız ‘’Seçimini değiştirmeli.’’ şeklindeyse, evet haklısınız. Çünkü son aşamada seçilen kapıyı değiştirmek araba kazanma ihtimalini tam iki kat artırıyor. Nasıl mı?"
          "Öncelikle üç kapı arasından yapılan bir seçim ile arabayı kazanma olasılığı 1/3, kazanamama (arkasında keçi olan kapıyı seçme) olasılığı ise 2/3’tür. Sunucu arkasında keçi olan bir kapıyı açıp geriye iki kapı bıraktığı zaman yarışmacının ilk seçtiği kapı ile arabayı kazanma olasılığı hâlâ 1/3’tür. Yani 2/3 olasılıkla araba yarışmacının seçmediği diğer kapının arkasındadır. Bu sebeple yarışmacı son aşamada seçimini değiştirirse arabayı kazanma olasılığını artırır."),
  PageDesing(
      imageURL:
          "https://bilimgenc.tubitak.gov.tr/sites/default/files/monty-hall-problemi-3.jpg",
      text:
          "Çoğu kişi, geriye iki kapı kalması nedeniyle arabayı kazanma-kaybetme olasılığını birbirine eşit yani %50-%50 olarak düşünüyor. Fakat bu şekilde düşünmek doğru değil. Çünkü yarışmanın sunucusu kapıların arkasında neler olduğunu biliyor ve açtığı kapının seçimini rastgele yapmıyor. "
          "Bu yarışmada gerçekleşebilecek 9 farklı durum vardır. Sunucu arkasında keçi olan kapıyı açtıktan sonra yarışmacının arabayı kazanma-kaybetme durumlarının tamamını tek tek inceleyelim."),
  PageDesing(
      text:
          "Görüldüğü üzere yarışmacı ilk yaptığı tercihini değiştirmezse 9 durumun sadece 3’ünde arabayı kazanır. Yani arabayı kazanma olasılığı 1/3’tür. Fakat ilk yaptığı tercihi arkasında keçi olan kapı açıldıktan sonra değiştirirse arabayı kazanma ihtimali 2/3’e yükselir. Böylece toplam 9 durumun 6’sında arabayı kazanır."
          "Monty Hall problemi, 1963-1976 yılları arasında ABD televizyonlarında yayınlanmış olmasına rağmen  1990 yılında popüler oldu. Parade isimli bir dergide okuyuculardan gelen soruların cevaplandığı bir köşe bulunuyordu. Bir okuyucudan gelen soru üzerine Monty Hall probleminin cevabı bu köşede yayımlandı. Ancak okurların çoğu bu çözümün doğruluğuna inanmadı ve dergiye çözümün yanlış olduğunu iddia eden 10.000 adet mektup geldi."),
];

class PageDesing extends StatelessWidget {
  late final String? imageURL;
  late final String text;

  PageDesing({this.imageURL = null, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: containerColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          imageURL != null
              ? Image.network(
                  imageURL!,
                )
              : Container(),
          SizedBox(
            height: 40,
          ),
          Container(
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ]),
      ),
    );
  }
}
