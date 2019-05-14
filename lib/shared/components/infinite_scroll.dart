import 'package:flutter/material.dart';
import 'package:twic_app/pages/root_page.dart';

class InfiniteScroll extends StatefulWidget {
  final Function fetch;
  final Function builder;
  final int count;
  ScrollController scroll;

  InfiniteScroll({this.fetch, this.builder, this.count, this.scroll}){
    if(null == scroll) scroll = RootPage.scroll;
  }

  @override
  InfiniteScrollState createState() => InfiniteScrollState();
}

class InfiniteScrollState extends State<InfiniteScroll> {
  int page = 0;
  bool loading = false;


  @override
  void initState() {
    super.initState();
    widget.scroll.addListener(() {
      double maxScroll = widget.scroll.position.maxScrollExtent;
      double currentScroll = widget.scroll.position.pixels;
      double delta = 200.0;
      if (maxScroll - currentScroll <= delta) {
        widget.fetch();
      }
    });
    widget.fetch();
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: widget.builder,
    itemCount: widget.count,
  );
}
