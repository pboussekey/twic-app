import 'package:flutter/material.dart';
import 'package:twic_app/pages/root_page.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/api/services/users.dart';
import 'package:twic_app/api/services/conversations.dart';
import 'package:twic_app/api/services/hashtags.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/users/userlist.dart';
import 'package:twic_app/pages/chat/conversation.dart';
import 'package:twic_app/pages/chat/create_group.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/shared/hashtags/hashtaglist.dart';

enum CreateState { OneToOne, Group, Channel }

class CreateConversation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateConversationState();
}

class CreateConversationState extends State<CreateConversation> {
  String search;
  TextEditingController _searchController = TextEditingController();
  CreateState state = CreateState.OneToOne;
  List<User> users = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {
          search = _searchController.text;
        }));
  }

  Widget _renderActions(mediaSize) {
    switch (state) {
      case CreateState.Group:
        return (users.length > 0
            ? Container(
                width: mediaSize.width,
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) => Button(
                        background: Colors.transparent,
                        padding: EdgeInsets.all(0),
                        child: Stack(children: <Widget>[
                          Avatar(
                            size: 40,
                            href: users[index].avatar?.href(),
                          ),
                          Container(
                            width: 50,
                            height: 40,
                          ),
                          Positioned(
                              top: 0,
                              left: 25,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Icon(
                                    Icons.cancel,
                                    color: Style.lightGrey,
                                    size: 16,
                                  )))
                        ]),
                        onPressed: () => setState(() => users.removeAt(index)),
                      ),
                ))
            : Container(
                height: 50,
                alignment: Alignment(0, 0),
                child: Text(
                  "Add people to this group chat below",
                  style: Style.get(fontSize: 15, color: Style.lightGrey),
                )));
        break;
      case CreateState.Channel:
        return Container(
            height: 50,
            alignment: Alignment(0, 0),
            child: Text(
              'Join the channel below, or create a new one',
              textAlign: TextAlign.start,
              style: Style.get(fontSize: 15, color: Style.lightGrey),
            ));
        break;
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Button(
              background: Colors.transparent,
              padding: EdgeInsets.only(right: 20, bottom: 10),
              onPressed: () => setState(() => state = CreateState.Group),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Style.mainColor,
                    ),
                    child: Icon(Icons.people, color: Colors.white),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('New group',
                      style: Style.get(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Style.darkGrey))
                ],
              ),
            ),
            Button(
              background: Colors.transparent,
              onPressed: () => setState(() => state = CreateState.Channel),
              padding: EdgeInsets.only(right: 20, bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 32,
                    width: 32,
                    alignment: Alignment(0, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Style.mainColor,
                    ),
                    child: Text('#', style: Style.whiteTitle),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('New channel',
                      style: Style.get(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Style.darkGrey))
                ],
              ),
            )
          ],
        );
        break;
    }
  }

  Widget _renderList(mediaSize) {
    switch (state) {
      case CreateState.Channel:
        return Container(
            height: mediaSize.height - 150,
            child: Conversations.join(
                onCompleted: (dynamic data) {
                  loading = false;
                  if (null != data) {
                    Conversation conversation =
                        Conversation.fromJson(data['joinChannel']);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ConversationPage(
                                  conversation: conversation,
                                )));
                  }
                },
                builder: (RunMutation join, QueryResult result) =>
                    Hashtags.getList(
                        search: search,
                        builder: (List<Hashtag> hashtags) => hashtags.length > 0
                            ? HashtagList(
                                list: hashtags,
                                renderAction: (Hashtag hashtag) => Container(),
                                onClick: (Hashtag hashtag) {
                                  if (loading) return;
                                  setState(() {
                                    loading = true;
                                  });
                                  join({'hashtag_id': hashtag.id});
                                })
                            : Conversations.createChannel(
                                onCompleted: (dynamic data) {
                                  loading = false;
                                  if (null != data) {
                                    Conversation conversation =
                                        Conversation.fromJson(
                                            data['createChannel']);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ConversationPage(
                                                    conversation:
                                                        conversation)));
                                  }
                                },
                                builder:
                                    (RunMutation create, QueryResult result) =>
                                        Padding(
                                          child: !loading
                                              ? Button(
                                                  text: 'Create Channel',
                                                  height: 40,
                                                  width: 150,
                                                  disabled: hashtags.length > 0,
                                                  onPressed: () {
                                                    if (loading) return;
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    create({'name': search});
                                                  })
                                              : Container(
                                                  width: 90,
                                                  alignment: Alignment(0, 0),
                                                  child:
                                                      CircularProgressIndicator()),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                        )))));
        break;
      default:
        return Container(
            height: mediaSize.height - 150,
            child: Users.getList(
                search: search,
                builder: (List<User> list) => UserList(
                    list: list,
                    renderAction: (User user) => CreateState.OneToOne == state
                        ? Container()
                        : Button(
                            padding: EdgeInsets.all(0),
                            background: Colors.transparent,
                            onPressed: () => setState(() => users.contains(user)
                                ? users.remove(user)
                                : users.add(user)),
                            child: Container(
                              height: 24,
                              width: 24,
                              padding: EdgeInsets.all(0),
                              child: users.contains(user)
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : null,
                              decoration: BoxDecoration(
                                  color: users.contains(user)
                                      ? Style.mainColor
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  border: users.contains(user)
                                      ? null
                                      : Border.all(color: Style.border)),
                            ),
                          ),
                    onClick: CreateState.OneToOne == state
                        ? (User user) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ConversationPage(
                                          user: user,
                                        )))
                            .then((dynamic value) => Navigator.pop(context))
                        : null)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                  "New ${CreateState.OneToOne == state ? 'Message' : CreateState.Group == state ? 'Group' : 'Channel'}",
                  style: Style.largeText),
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Style.lightGrey,
                  ),
                  onPressed: () => Navigator.pop(context)),
              actions: <Widget>[
                CreateState.Group == state && users.length > 0
                    ? Padding(
                        child: Button(
                          text: 'Next',
                          height: 40,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CreateGroup(users: users))),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      )
                    : Container()
              ],
            )),
        body: RootPage(
            child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Input(
                  controller: _searchController,
                  color: Style.greyBackground,
                  shadow: false,
                  before: Text('To: ',
                      style: Style.get(fontSize: 17, color: Style.lightGrey)),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Style.border))),
                child: _renderActions(mediaSize)),
            _renderList(mediaSize)
          ],
        )));
  }
}
