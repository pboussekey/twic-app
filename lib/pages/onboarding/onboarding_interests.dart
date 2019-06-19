import 'package:flutter/material.dart';
import 'package:twic_app/shared/form/autocomplete.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/pages/onboarding/onboarding_content_state.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/hashtags/hashtags.dart';
import 'package:twic_app/api/services/hashtags.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/style/twic_font_icons.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/api/services/cache.dart';

class OnboardingInterests extends OnboardingContentState {


  OnboardingInterests()
      : super(
            title: 'What are your interests?',
            text:
                'Select a Channel to follow content in your feed and discuss.',
            next: OnboardingState.Connect,
            previous: OnboardingState.Details,
            isCompleted: () => true){
    child = AppCache.getWidget<Hashtag>(
        params: {"followed": true},
        builder: (List<int> followed) {
          return AppCache.getWidget<Hashtag>(
              params: {
                "followed": false,
                "university_id": Session.instance.user.university.id,
              },
              builder: (List<int> suggestions) {
                return _OnboardingInterestsContent(
                  followed: followed,
                  suggestions: suggestions,
                );
              });
        });
  }
}

class _OnboardingInterestsContent extends StatefulWidget {
  final List<int> followed;
  final List<int> suggestions;



  _OnboardingInterestsContent({this.followed, this.suggestions});

  @override
  State createState() => _OnboardingInterestsContentState();
}

class _OnboardingInterestsContentState
    extends State<_OnboardingInterestsContent> {
  GlobalKey hashtagKey;
  String search = "";
  UniqueKey _key = UniqueKey();
  TextEditingController _controller = TextEditingController();

  void refresh(){
    if(mounted){
      print("REFRESH");
      setState(() {
        _key = UniqueKey();

      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => search = _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    return AppCache.getWidget<Hashtag>(
        params: {"search": search},
        onCompleted: refresh,
        builder: (List<int> autocompleteSuggestions) {
          List<Hashtag> hashtags = autocompleteSuggestions
              .map((int hashtag_id) => AppCache.getModel<Hashtag>(hashtag_id))
              .where((h) => null != h)
              .toList();
          List<Hashtag> _suggestions = widget.suggestions
              .map((int hashtag_id) => AppCache.getModel<Hashtag>(hashtag_id))
              .where((h) => null != h)
              .toList();
          List<Hashtag> _followed = widget.followed
              .map((int hashtag_id) => AppCache.getModel<Hashtag>(hashtag_id))
              .where((h) => null != h)
              .toList();

          return Column(
            key: _key,
            children: <Widget>[
              Hashtags.follow(
                  builder: (RunMutation runMutation, QueryResult result) =>
                      Autocomplete(
                        fieldKey: hashtagKey,
                        placeholder: 'Search for a #Channel',
                        suggestions: hashtags
                            .map((Hashtag hashtag) => AutoCompleteElement(
                                name: hashtag.name, data: hashtag))
                            .toList(),
                        minLength: 0,
                        controller: _controller,
                        size: mediaSize.width - 100,
                        icon: TwicFont.search,
                        iconSize: 15,
                        itemBuilder: (BuildContext context,
                                AutoCompleteElement item) =>
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("#" + item.data.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: Style.largeText),
                                          Text(
                                              "${item.data.nbfollowers} follower${item.data.nbfollowers > 1 ? 's' : ''}",
                                              style: Style.lightText),
                                        ]),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Center(
                                      child: Container(
                                    child: Text(
                                        item.data.followed
                                            ? 'Following'
                                            : 'Follow',
                                        style: item.data.followed
                                            ? Style.whiteText
                                            : Style.lightText),
                                    decoration: BoxDecoration(
                                        color: item.data.followed
                                            ? Style.grey
                                            : Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        border: item.data.followed
                                            ? null
                                            : Border.all(
                                                color: Style.lightGrey)),
                                    height: 24.0,
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10.0,
                                        top: 4,
                                        bottom: 2.5),
                                  ))
                                ],
                              ),
                            ),
                        textChanged: (String text) => setState(() {
                              search = text;
                            }),
                        itemSubmitted: (AutoCompleteElement item) =>
                            setState(() {
                              Hashtag hashtag = item.data;
                              if (!hashtag.followed) {
                                search = "";
                                _controller.text = "";
                                _key = UniqueKey();
                                hashtag.nbfollowers++;
                                hashtag.followed = true;
                                widget.followed.insert(0, hashtag.id);
                                widget.suggestions.remove(hashtag.id);
                                runMutation({'hashtag_id': hashtag.id});
                              }
                            }),
                      )),
              widget.followed.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Followed",
                          style: Style.titleStyle,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        HashtagsList(
                            list: _followed,
                            onPressed: (Hashtag hashtag, bool _followed) {
                              setState(() {

                                _key = UniqueKey();
                                widget.followed.remove(hashtag.id);
                                widget.suggestions.insert(0, hashtag.id);
                              });
                            }),
                      ],
                    )
                  : Container(),
              widget.suggestions.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Suggestions",
                          style: Style.titleStyle,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        HashtagsList(
                          list: _suggestions,
                          onPressed: (Hashtag hashtag, bool _followed) {
                            setState(() {
                              _key = UniqueKey();
                              widget.suggestions
                                  .remove(hashtag.id);
                              widget.followed.insert(0, hashtag.id);
                            });
                          },
                        ),
                      ],
                    )
                  : Container()
            ],
          );
        });
  }
}
