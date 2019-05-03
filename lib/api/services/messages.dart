import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/message.dart';
import 'package:flutter/material.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Messages {
  static Widget getList({int conversation_id, Function builder}) {
    return api.query<Message>(
        query: """      
         query messages(\$conversation_id: ID!) {
          messages(conversation_id: \$conversation_id){
                id
                text
                createdAt
                user{ 
                  id
                  firstname 
                  lastname 
                  avatar{ name bucketname token } 
                }
              }
          }
          """,
        params: {'conversation_id': conversation_id},
        onComplete: (dynamic data) =>
            ((data['messages'] ?? []) as List<dynamic>)
                .map((dynamic message) => Message.fromJson(message))
                .toList(),
        builder: builder);
  }
}
