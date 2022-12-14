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
      text: "??smini ABD televizyonlar??nda 1963-1976 y??llar?? aras??nda "
          "yay??nlanan Let???s Make a Deal (Bir Anla??ma Yapal??m) isimli yar????ma program??n??n sunucusundan alan Monty Hall problemi asl??nda basit bir olas??l??k sorusuydu."),
  PageDesing(
    imageURL:
        "https://bilimgenc.tubitak.gov.tr/sites/default/files/monty-hall-problemi-2.jpg",
    text:
        "Yar????madaki ???? kap??dan birinin arkas??nda son model bir araba, di??er ikisinin arkas??nda ise ke??i vard??r. Yar????mac??lar??n amac??, araban??n bulundu??u kap??y?? do??ru tahmin etmek ve arabay?? kazanmakt??r. "
        "Araban??n hangi kap??n??n arkas??nda oldu??unu bilen sunucu Monty Hall, yar????mac??dan bir kap?? se??mesini ister. Yar????mac??n??n ???? kap?? aras??ndan yapt?????? bu se??im ile arabay?? kazanma olas??l?????? 1/3 iken kazanamama olas??l?????? 2/3???t??r. Yar????mac??n??n se??ti??i kap?? a????lmadan ??nce Monty Hall, arkas??nda ke??i olan bir kap??y?? a??ar. (Yar????mac?? hangi kap??y?? se??erse se??sin, geriye kalan kap??lardan en az birinin arkas??nda ke??i bulunmak zorundad??r.) Bu durumda kapal?? iki kap?? kal??r: yar????mac??n??n se??ti??i kap?? ile se??medi??i di??er kap??.",
  ),
  PageDesing(
      text:
          "Monty Hall, yar????mac??n??n se??ti??i kap??y?? a??madan ??nce yar????man??n heyecan??n?? art??rmak ister ve yar????mac??ya yeni bir se??im yapma hakk?? verir. Yar????mac?? ya ilk se??ti??i kap?? ile devam eder ya da fikrini de??i??tirip di??er kap??y?? se??er. Son olarak se??ilen kap?? a????l??r ve yar????mac??n??n arabay?? kazan??p kazanamad?????? belli olur."
          "Yar????may?? kazanmak biraz ??ans i??idir. ????nk?? araban??n kesin olarak kazan??laca???? bir durum s??z konusu de??il. Fakat kazanma ihtimali y??ksek tercihler yapmak yar????mac??n??n ??ans??n?? art??raca???? i??in daha ak??ll??ca olacakt??r."),
  PageDesing(
      text:
          "Peki sizce yar????mac?? son iki kap?? kald??????nda se??imini de??i??tirmeli mi yoksa ilk se??ti??i kap??da ??srarc?? m?? olmal??? Ba??ka bir deyi??le, son a??amada ilk se??ilen kap??y?? de??i??tirmek araba kazanma ihtimalini art??r??r m??, de??i??tirmez mi yoksa azalt??r m???"
          "E??er cevab??n??z ??????Se??imini de??i??tirmeli.?????? ??eklindeyse, evet hakl??s??n??z. ????nk?? son a??amada se??ilen kap??y?? de??i??tirmek araba kazanma ihtimalini tam iki kat art??r??yor. Nas??l m???"
          "??ncelikle ???? kap?? aras??ndan yap??lan bir se??im ile arabay?? kazanma olas??l?????? 1/3, kazanamama (arkas??nda ke??i olan kap??y?? se??me) olas??l?????? ise 2/3???t??r. Sunucu arkas??nda ke??i olan bir kap??y?? a????p geriye iki kap?? b??rakt?????? zaman yar????mac??n??n ilk se??ti??i kap?? ile arabay?? kazanma olas??l?????? h??l?? 1/3???t??r. Yani 2/3 olas??l??kla araba yar????mac??n??n se??medi??i di??er kap??n??n arkas??ndad??r. Bu sebeple yar????mac?? son a??amada se??imini de??i??tirirse arabay?? kazanma olas??l??????n?? art??r??r."),
  PageDesing(
      imageURL:
          "https://bilimgenc.tubitak.gov.tr/sites/default/files/monty-hall-problemi-3.jpg",
      text:
          "??o??u ki??i, geriye iki kap?? kalmas?? nedeniyle arabay?? kazanma-kaybetme olas??l??????n?? birbirine e??it yani %50-%50 olarak d??????n??yor. Fakat bu ??ekilde d??????nmek do??ru de??il. ????nk?? yar????man??n sunucusu kap??lar??n arkas??nda neler oldu??unu biliyor ve a??t?????? kap??n??n se??imini rastgele yapm??yor. "
          "Bu yar????mada ger??ekle??ebilecek 9 farkl?? durum vard??r. Sunucu arkas??nda ke??i olan kap??y?? a??t??ktan sonra yar????mac??n??n arabay?? kazanma-kaybetme durumlar??n??n tamam??n?? tek tek inceleyelim."),
  PageDesing(
      text:
          "G??r??ld?????? ??zere yar????mac?? ilk yapt?????? tercihini de??i??tirmezse 9 durumun sadece 3?????nde arabay?? kazan??r. Yani arabay?? kazanma olas??l?????? 1/3???t??r. Fakat ilk yapt?????? tercihi arkas??nda ke??i olan kap?? a????ld??ktan sonra de??i??tirirse arabay?? kazanma ihtimali 2/3???e y??kselir. B??ylece toplam 9 durumun 6???s??nda arabay?? kazan??r."
          "Monty Hall problemi, 1963-1976 y??llar?? aras??nda ABD televizyonlar??nda yay??nlanm???? olmas??na ra??men  1990 y??l??nda pop??ler oldu. Parade isimli bir dergide okuyuculardan gelen sorular??n cevapland?????? bir k????e bulunuyordu. Bir okuyucudan gelen soru ??zerine Monty Hall probleminin cevab?? bu k????ede yay??mland??. Ancak okurlar??n ??o??u bu ????z??m??n do??rulu??una inanmad?? ve dergiye ????z??m??n yanl???? oldu??unu iddia eden 10.000 adet mektup geldi."),
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
