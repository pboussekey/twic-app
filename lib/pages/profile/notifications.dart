import 'package:flutter/material.dart';
import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/api/services/notifications.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/components/infinite_scroll.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  bool loading = false;
  bool initialized = false;
  List<TwicNotification> notifications = [];
  int page = 0;

  String _renderDate(DateTime date) {
    Duration since = DateTime.now().difference(date);

    if (since.inSeconds < 60) {
      return '${since.inSeconds}s';
    } else if (since.inMinutes < 60) {
      return '${since.inMinutes}m';
    } else if (since.inHours < 24) {
      return '${since.inHours}h';
    } else if (since.inDays < 30) {
      return '${since.inDays}d';
    }

    return DateFormat.yMMMd().format(new DateTime.now());
  }

  RichText ntfText(TwicNotification notification) {
    List<TextSpan> texts = [];
    String text = notification.text;
    int userIdx = text.indexOf('{user}');
    if (userIdx > 0) {
      texts.add(TextSpan(
          text: text.substring(0, userIdx),
          style: Style.get(fontSize: 14, fontWeight: FontWeight.w300)));
    }
    if (userIdx >= 0) {
      texts.add(TextSpan(
          text: '${notification.user.firstname} ${notification.user.lastname}',
          style: Style.text));
      userIdx += 6;
    } else {
      userIdx = 0;
    }
    int countIdx = text.indexOf(' {count}');
    if (countIdx > userIdx) {
      texts.add(TextSpan(
          text: text.substring(userIdx, countIdx),
          style: Style.get(fontSize: 14, fontWeight: FontWeight.w300)));
    }
    if (countIdx >= 0) {
      if (notification.count > 0) {
        texts.add(TextSpan(text: ' and ', style: Style.text));
        texts.add(TextSpan(
            text:
                '${notification.count} other${notification.count > 1 ? "s" : ""}',
            style: Style.text));
      }
      countIdx += 8;
    }
    if (countIdx < text.length) {
      texts.add(TextSpan(
          text: text.substring(countIdx),
          style: Style.get(fontSize: 14, fontWeight: FontWeight.w300)));
    }
    TextSpan first = texts.removeAt(0);
    return RichText(
        overflow: TextOverflow.clip,
        text: TextSpan(text: first.text, style: first.style, children: texts));
  }

  void _fetch() async {
    if (loading) return;
    loading = true;
    initialized = true;
    print("LOAD NOTIFICATIONS");
    Notifications.load(page: page, count: 10)
        .then((List<TwicNotification> _notifications) {
      notifications.addAll(_notifications);
      print(notifications);
      loading = false;
      if (mounted) {
        setState(() {});
      }
    });
    page++;
  }

  @override
  Widget build(BuildContext context) {
    Notifications.hasNotification = false;
    Size mediaSize = MediaQuery.of(context).size;
    return RootPage(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Notifications",
          textAlign: TextAlign.center,
          style: Style.titleStyle,
        ),
      ),
      child: Container(
          height: mediaSize.height - 80,
          child: InfiniteScroll(
            fetch: _fetch,
            count: notifications.length,
            builder: (BuildContext context, int index) {
              TwicNotification notification = notifications[index];
              return Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Style.border))),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Avatar(
                        size: 35,
                        href: notification.user.avatar?.href(),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(child: ntfText(notification)),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _renderDate(notification.createdAt),
                        style: Style.lightText,
                      )
                    ],
                  ));
            },
          )),
    );
  }
}
