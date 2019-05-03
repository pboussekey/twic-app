import 'package:flutter/material.dart';
import 'package:twic_app/shared/form/autocomplete.dart';
import 'package:twic_app/pages/onboarding/onboarding_states.dart';
import 'package:twic_app/pages/onboarding/onboarding_content_state.dart';
import 'package:twic_app/api/models/hashtag.dart';
import 'package:twic_app/shared/hashtags/hashtags.dart';
import 'package:twic_app/api/services/hashtags.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/button.dart';

class OnboardingInterests extends OnboardingContentState {
  Widget _render() {
    return Hashtags.followed(builder: (List<Hashtag> followed) {
      return Hashtags.suggestions(builder: (List<Hashtag> suggestions) {
        return _OnboardingInterestsContent(
          followed: followed,
          suggestions: suggestions,
        );
      });
    });
  }

  OnboardingInterests()
      : super(
            title: 'What are your interests?',
            text:
                'Select a topic to see content about it in your feed. Your interests won’t appear in your profile.',
            next: OnboardingState.Connect,
            previous: OnboardingState.Details,
            isCompleted: () => true) {
    this.render = _render;
  }
}

class _OnboardingInterestsContent extends StatefulWidget {
  final List<Hashtag> followed;
  final List<Hashtag> suggestions;

  _OnboardingInterestsContent({this.followed, this.suggestions});

  @override
  State createState() => _OnboardingInterestsContentState();
}

class _OnboardingInterestsContentState
    extends State<_OnboardingInterestsContent> {
  GlobalKey hashtagKey;
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Hashtags.getList(
            search: search,
            cache: false,
            builder: (List<Hashtag> autocompleteSuggestions) => Hashtags.follow(
                builder: (RunMutation runMutation, QueryResult result) =>
                    Autocomplete(
                      fieldKey: hashtagKey,
                      placeholder: 'Search a #Hashtag',
                      suggestions: autocompleteSuggestions
                          .map((Hashtag hashtag) => AutoCompleteElement(
                              name: hashtag.name, data: hashtag))
                          .toList(),
                      minLength: 0,
                      icon: Icons.search,
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
                                            style: Style.largeText),
                                        Text(
                                            "${item.data.nbfollowers} follower${item.data.nbfollowers > 1 ? 's' : ''}",
                                            style: Style.lightText),
                                      ]),
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
                                          : Border.all(color: Style.lightGrey)),
                                  height: 20.0,
                                  padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10.0,
                                      top: 2.5,
                                      bottom: 2.5),
                                ))
                              ],
                            ),
                          ),
                      textChanged: (String text) => setState(() {
                            search = text;
                          }),
                      itemSubmitted: (AutoCompleteElement item) => setState(() {
                            Hashtag hashtag = item.data;
                            if(hashtag.followed) return;
                            hashtag.nbfollowers++;
                            hashtag.followed = true;
                            widget.followed.insert(0, hashtag);
                            widget.suggestions.remove(hashtag);
                            runMutation({'hashtag_id': hashtag.id});
                          }),
                    ))),
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
                      list: widget.followed,
                      onPressed: (Hashtag hashtag, bool _followed) {
                        setState(() {
                          widget.followed.remove(hashtag);
                          widget.suggestions.insert(0, hashtag);
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
                    list: widget.suggestions,
                    onPressed: (Hashtag hashtag, bool _followed) {
                      setState(() {
                        widget.suggestions
                            .removeWhere((Hashtag h) => h.id == hashtag.id);
                        widget.followed.insert(0, hashtag);
                      });
                    },
                  ),
                ],
              )
            : Container()
      ],
    );
  }
}
