import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/components/round_picture.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/style/twic_font_icons.dart';

class HashtagList extends StatelessWidget {
  final List<Hashtag> list;
  final Function renderAction;
  final Function onClick;

  HashtagList({this.list, this.renderAction, this.onClick});

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Container(
        child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => Button(
          background: Colors.transparent,
          onPressed: null != onClick ? () => onClick(list[index]) : null,
          padding:
              EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
          height: 51,
          width: mediaSize.width,
          child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Stack(children:[RoundPicture(
                    width: 20,
                    padding: EdgeInsets.all(5),
                    height: 20,
                    background: Style.darkPurple,
                    picture: 'assets/logo-white.png',
                  ),
                    Container(
                      alignment: Alignment.bottomRight,
                      height: 35.0,
                      width: 35.0,
                      child: ClipRRect(
                          borderRadius: new BorderRadius.circular(20.0),
                          child: Container(
                            child: Icon(TwicFont.hashtag, color: Colors.white, size: 10,),
                            color: Style.mainColor,
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                          )),
                    )
                  ]),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${list[index].name}", style: Style.text),
                      Text(
                          "${list[index].nbfollowers} follower${list[index].nbfollowers > 1 ? 's' : ''}",
                          style: Style.lightText),
                    ],
                  ))
                ]),
                null == renderAction
                    ? Button(
                        height: 30.0,
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        text: !list[index].followed ? 'Follow' : 'Unfollow',
                        background: !list[index].followed
                            ? Style.mainColor
                            : Style.veryLightGrey,
                        color: !list[index].followed
                            ? Colors.white
                            : Style.lightGrey,
                      )
                    : renderAction(list[index])
              ])),
      itemCount: list.length,
    ));
  }
}
