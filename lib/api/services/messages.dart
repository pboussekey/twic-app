import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/message.dart';
import 'package:flutter/material.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Messages {

  api.SocketClient socketClient = api.SocketClient('ws://10.0.2.2:3000/subscriptions');

  static Widget getList({int conversation_id, Function builder}) => api.query<Message>(
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
                attachment{ name bucketname token } 
              }
          }
          """,
        cache: false,
        params: {'conversation_id': conversation_id},
        onComplete: (dynamic data) =>
            ((data['messages'] ?? []) as List<dynamic>)
                .map((dynamic message) => Message.fromJson(message))
                .toList(),
        builder: builder);


  static Widget onMessage({int conversation_id, Function builder }) =>
      api.subscription(
          operation : "onMessage",
          query: """
          subscription onMessage(\$conversation_id: ID!){
            onMessage(conversation_id: \$conversation_id){
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
          params: {
            'conversation_id' : conversation_id
          },
          builder : builder);


  static api.Mutation send({Function builder}) => api.mutation(query: """      
         mutation sendMessage(\$conversation_id: ID!, \$text : String,  \$attachment : FileInputDef) {
          sendMessage(conversation_id: \$conversation_id, text : \$text, attachment : \$attachment){
                success
              }
          }
          """, builder: builder);
}


