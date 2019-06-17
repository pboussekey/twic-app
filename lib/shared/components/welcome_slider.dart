import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/locale/translations.dart';
import 'package:twic_app/shared/form/button.dart';

import 'package:twic_app/shared/components/custom_painter.dart';

class WelcomeSlider extends StatefulWidget {
  /// An array of Slide object
  final List<Slide> slides;

  // NEXT, DONE button
  /// Fire when press DONE button
  final Function onDonePress;

  // Constructor
  WelcomeSlider({
    @required this.slides,
    this.onDonePress,
  });

  @override
  WelcomeSliderState createState() => new WelcomeSliderState(
        slides: this.slides,
        onDonePress: this.onDonePress,
      );
}

class WelcomeSliderState extends State<WelcomeSlider>
    with SingleTickerProviderStateMixin {
  /// An array of Slide object
  final List<Slide> slides;

  /// Fire when press DONE button
  Function onDonePress;

  int nextIndex = 0;

  // Constructor
  WelcomeSliderState({
    // List slides
    @required this.slides,

    // Skip button
    @required this.onDonePress,
  });

  TabController tabController;

  List<Widget> tabs = new List();
  List<Widget> dots = new List();

  @override
  void initState() {
    super.initState();

    tabController = new TabController(length: slides.length, vsync: this);
    tabController.addListener(() {
      // To change dot color
      this.setState(() {});
    });

    // Done button
    if (onDonePress == null) {
      onDonePress = () {};
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDragging = false;
    _buildTabs();
    return Container(
      child: DefaultTabController(
        length: slides.length,
        child: Stack(
          children: <Widget>[
            TabBarView(
              children: _buildTabs(),
              controller: tabController,
            ),
            _buildFooter(),
            GestureDetector(
              onHorizontalDragStart: (DragStartDetails details) {
                isDragging = true;
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                this.setState(() {});
                if (isDragging &&
                    details.primaryDelta > 0 &&
                    tabController.index > 0) {
                  tabController.animateTo(tabController.index - 1);
                } else if (isDragging && details.primaryDelta < 0) {
                  if (tabController.index < slides.length - 1) {
                    tabController.animateTo(tabController.index + 1);
                  } else {
                    this.onDonePress();
                  }
                }
                isDragging = false;
              },
              onHorizontalDragCancel: () {
                isDragging = false;
                this.setState(() {});
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                isDragging = false;
                this.setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Positioned(
      child: Row(
        children: <Widget>[
          // Skip button
          (tabController.index > 0)
              ? Container(
                  width: 100.0,
                  child: FlatButton(
                    child: Text(translations.text('slider.actions.previous')),
                    onPressed: () {
                      this.setState(() {});
                      tabController.animateTo(tabController.index - 1);
                    },
                    textColor: Style.lightGrey,
                  ))
              : Container(
                  width: 100.0,
                ),

          // Dot indicator
          Flexible(
              child: Row(
            children: _buildNavigation(),
            mainAxisAlignment: MainAxisAlignment.center,
          )),

          // Next, Done button
          Container(
            width: 100.0,
            child: tabController.index + 1 == slides.length
                ? Button(
                    height: 41,
                    text: translations.text('slider.actions.done'),
                    onPressed: onDonePress,
                  )
                : FlatButton(
                    onPressed: () {
                      this.setState(() {});
                      tabController.animateTo(tabController.index + 1);
                    },
                    child: Text(translations.text('slider.actions.next')),
                    textColor: Style.darkGrey,
                  ),
          ),
        ],
      ),
      bottom: 10.0,
      left: 10.0,
      right: 10.0,
      height: 50.0,
    );
  }

  List<Widget> _buildTabs() {
    tabs = List<Widget>();
    for (int i = 0; i < slides.length; i++) {
      tabs.add(
        _buildTab(
          slides[i].title,
          slides[i].description,
          slides[i].pathImage,
          slides[i].widthImage,
          slides[i].heightImage,
          slides[i].marginImage,
          slides[i].imageFit,
          slides[i].backgroundColor,
          i == tabController.index,
        ),
      );
    }
    return tabs;
  }

  Widget _buildTab(
      // Title
      String title,

      // Description
      String description,

      // Image
      String pathImage,
      double widthImage,
      double heightImage,
      double marginImage,
      BoxFit imageFit,

      // Background color
      Color backgroundColor,
      bool isActive) {
    Size mediaSize = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRect(
                      child: CustomPaint(
                          painter:
                              CustomBackgroundPainter(color: backgroundColor),
                          size: Size(mediaSize.width, mediaSize.height * 0.55)),
                    ),
                    Center(
                        child: Container(
                      width: mediaSize.width,
                      margin:
                          EdgeInsets.only(top: mediaSize.height * marginImage),
                      child: null != pathImage
                          ? Image.asset(
                              pathImage,
                              width: widthImage ?? null,
                              height: null != heightImage
                                  ? mediaSize.height * heightImage
                                  : null,
                              fit: imageFit ?? BoxFit.fitWidth,
                            )
                          : Container(),
                    )),
                    Container(height: mediaSize.height,),
                    Positioned(
                        bottom: 80,
                        right: 0,
                        left: 0,
                        child: Container(
                          alignment: Alignment(1, 1),
                          height: mediaSize.height * 0.35,
                          padding:
                          EdgeInsets.only(right: 20.0, left: 20.0, bottom: 100.0, top : 25),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  title,
                                  style: Style.titleStyle,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                                child: Text(
                                  description,
                                  style: Style.greyText,
                                  textAlign: TextAlign.center,
                                  maxLines: 100,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ],
            ),
            isActive
                ? Container(
                    width: 0.0,
                    height: 0.0,
                  )
                : Container(
                    decoration:
                        BoxDecoration(color: Color.fromARGB(100, 0, 0, 0)),
                  ),
          ],
        ));
  }

  renderTabContent() {}

  List<Widget> _buildNavigation() {
    dots.clear();
    for (int i = 0; i < slides.length; i++) {
      Color currentColor;
      if (tabController.index >= i) {
        currentColor = Style.darkGrey;
      } else {
        currentColor = Style.lightGrey;
      }
      dots.add(renderDot(8.0, currentColor));
    }
    return dots;
  }

  Widget renderDot(double radius, Color color) {
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius / 2)),
      width: radius,
      height: radius,
      margin: EdgeInsets.all(radius / 2),
    );
  }
}

class Slide {
  // Title
  /// Change text title at top
  String title;

  // Image
  /// Path to your local image
  String pathImage;

  /// Width of image
  double widthImage;

  /// Height of image
  double heightImage;

  /// Height of image
  double marginImage;

  BoxFit imageFit;

  //endregion

  // Description
  /// Change text description at bottom
  String description;

  // Background color
  /// Background tab color
  Color backgroundColor;

  Slide({
    // Title
    this.title,

    // Image (if specified centerWidget is not displayed)
    this.pathImage,
    this.widthImage,
    this.heightImage,
    this.marginImage,
    this.imageFit,

    // Description
    this.description,

    // Background color
    this.backgroundColor,
  });
}
