import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/api/services/hashtags.dart';

class HashtagWidget extends StatefulWidget {
  final Hashtag hashtag;
  final Function onPressed;
  bool hidePicture;

  HashtagWidget({@required this.hashtag, this.onPressed, this.hidePicture});

  @override
  State createState() => _HashtagState();
}

class _HashtagState extends State<HashtagWidget> {
  @override
  Widget build(BuildContext context) {
    Hashtag hashtag = widget.hashtag;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Style.shadow,
              offset: Offset(10.0, 10.0),
              spreadRadius: 3.0,
              blurRadius: 9.0)
        ],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Icon(
                    Icons.blur_circular,
                    color: Style.grey,
                    size: 40,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    height: 45.0,
                    width: 45.0,
                    child: ClipRRect(
                        borderRadius: new BorderRadius.circular(20.0),
                        child: Container(
                          child: Text("#",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          color: Style.mainColor,
                          height: 20,
                          width: 20,
                          alignment: Alignment.center,
                        )),
                  )
                ],
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("#" + hashtag.name, style: Style.text),
                      Text(
                          "${hashtag.nbfollowers} follower${hashtag.nbfollowers > 1 ? 's' : ''}",
                          style: Style.lightText),
                    ]),
              ),
              Center(
                  child: hashtag.followed
                      ? Hashtags.unfollow(
                          builder:
                              (RunMutation runMutation, QueryResult result) {
                            return Button(
                                text: 'Following',
                                height: 20.0,
                                padding: EdgeInsets.all(0),
                                fontSize: 12.0,
                                onPressed: () => setState(() {
                                      hashtag.followed = false;
                                      hashtag.nbfollowers--;
                                      if (null != widget.onPressed) {
                                        widget.onPressed(false);
                                      }
                                      runMutation({"hashtag_id" : hashtag.id});
                                    }));
                          })
                      : Hashtags.follow(
                          builder:
                              (RunMutation runMutation, QueryResult result) {
                            return Button(
                                text: 'Follow',
                                background: Colors.white,
                                color: Style.lightGrey,
                                border: Border.all(color: Style.lightGrey),
                                height: 20.0,
                                padding: EdgeInsets.all(0),
                                fontSize: 12.0,
                                onPressed: () => setState(() {
                                      hashtag.followed = true;
                                      hashtag.nbfollowers++;
                                      if (null != widget.onPressed) {
                                        widget.onPressed(true);
                                      }
                                      runMutation({"hashtag_id" : hashtag.id});
                                    }));
                          }))
            ],
          )),
    );
  }
}
