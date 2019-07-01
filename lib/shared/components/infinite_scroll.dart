import 'package:flutter/material.dart';
import 'package:twic_app/pages/root_page.dart';

class InfiniteScroll extends StatefulWidget {
  final Function fetch;
  final Function builder;
  final int count;
  ScrollController scroll;
  final bool reverse;
  final bool shrink;
  final int delta;
  final Axis direction;
  final Function onScroll;

  InfiniteScroll(
      {this.fetch,
      this.direction = Axis.vertical,
      this.shrink = true,
      this.builder,
      this.onScroll,
      this.count,
      this.scroll,
      this.delta = 200,
      this.reverse = false}) {
    if (null == scroll) {
      scroll = RootPage.scroll;
    }
  }

  @override
  InfiniteScrollState createState() => InfiniteScrollState();
}

class InfiniteScrollState extends State<InfiniteScroll> {
  int page = 0;
  bool loading = false;
  double previousScroll = 0;

  void _listener() {
    double maxScroll = widget.scroll.position.maxScrollExtent;
    double currentScroll = widget.scroll.offset;
    bool scrolled = widget.reverse
        ? widget.scroll.offset < previousScroll
        : widget.scroll.offset > previousScroll;
    double scroll = widget.reverse ? currentScroll : maxScroll - currentScroll;
    if (scrolled && scroll <= widget.delta) {
      widget.fetch();
    }
    if (null != widget.onScroll) {
      widget.onScroll();
    }
    previousScroll = widget.scroll.offset;
  }

  @override
  void initState() {
    super.initState();
    widget.scroll.addListener(_listener);
    widget.fetch();
  }

  @override
  void dispose() {
    widget.scroll.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
        scrollDirection: widget.direction,
        controller: widget.scroll != RootPage.scroll ? widget.scroll : null,
        shrinkWrap: widget.scroll == RootPage.scroll || widget.shrink,
        physics: widget.shrink
            ? NeverScrollableScrollPhysics()
            : PageScrollPhysics(),
        reverse: widget.reverse,
        itemBuilder: widget.builder,
        itemCount: widget.count,
      );
}
