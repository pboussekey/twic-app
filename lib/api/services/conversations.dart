import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/conversation.dart';
import 'package:flutter/material.dart';

class Conversations {
  static Widget getList({Function builder}) {
    return api.query<Conversation>(
        query: "query{conversations{id name last lastDate  users{id firstname lastname avatar{ name bucketname token }}}}",
        onComplete: (dynamic data) => (data['conversations'] as List<dynamic>)
            .map((dynamic conversation) => Conversation.fromJson(conversation)).toList(),
        builder: builder);
  }
}
