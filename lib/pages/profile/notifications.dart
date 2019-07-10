import 'package:flutter/material.dart';
import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/components/infinite_scroll.dart';

class NotificationsPage extends StatefulWidget{

  @override
  State<NotificationsPage> createState() => NotificationsPageState();

}

class NotificationsPageState extends State<NotificationsPage>{

  @override
  Widget build(BuildContext context) {
    return RootPage(
      appBar: AppBar(elevation: 0,
      title: Text("Notifications", style: Style.titleStyle,),
      ),
      child: Column(

      ),
    );
  }

}