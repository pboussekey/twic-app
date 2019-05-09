import 'package:flutter/material.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'package:twic_app/style/style.dart';

class FileSlider extends StatefulWidget {
  List<TwicFile> files;
  Function builder;

  FileSlider({@required this.files, this.builder});

  @override
  FileSliderState createState() => FileSliderState();
}

class FileSliderState extends State<FileSlider>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int index = 0;
  bool dragging = false;

  @override
  void initState() {
    super.initState();

    _controller = new TabController(
        length: widget.files.length, vsync: this, initialIndex: 0);
  }

  Widget _renderSliderFooter(int n, int index) {
    List<Widget> nav = [];
    for (int i = 0; i < n; i++) {
      nav.add(Container(
        height: 5,
        width: 5,
        margin: EdgeInsets.only(top: 10, right: 5),
        decoration: BoxDecoration(
            color: i == index ? Style.darkGrey : Style.lightGrey,
            borderRadius: BorderRadius.all(Radius.circular(2.5))),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: nav,
    );
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<TwicFile> files = widget.files;
    List<Widget> pictures = [];
    files.forEach((file) => pictures.add(widget.builder(file)));
    return files.length == 1
        ? ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: width * 0.8,
              minWidth: width,
              maxHeight: width * 0.8,
              maxWidth: width,
            ),
            child: pictures[0])
        : Container(
            height: width,
            width: width,
            child: Stack(children: [
              Column(children: <Widget>[
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: width * 0.8,
                    minWidth: width,
                    maxHeight: width * 0.8,
                    maxWidth: width,
                  ),
                  child:
                      TabBarView(controller: _controller, children: pictures),
                ),
                _renderSliderFooter(files.length, index)
              ]),
              GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  if (!dragging) {
                    dragging = true;
                    if (details.primaryDelta > 0 && _controller.index > 0) {
                      _controller.animateTo(_controller.index - 1);
                    } else if (details.primaryDelta < 0 &&
                        _controller.index < files.length - 1) {
                      _controller.animateTo(_controller.index + 1);
                    }
                    index = _controller.index;
                  }
                });
              }, onHorizontalDragCancel: () {
                this.setState(() {
                  dragging = false;
                });
              }, onHorizontalDragEnd: (DragEndDetails details) {
                this.setState(() {
                  dragging = false;
                });
              }),
            ]));
  }
}
