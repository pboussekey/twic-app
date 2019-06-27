import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Messages {
  static Map<String, int> unread = { "MESSAGE" : 0, "GROUP" : 0, "CHANNEL" : 0};
  static int lastMessage;

  api.SocketClient socketClient =
      api.SocketClient('ws://10.0.2.2:3000/subscriptions');

  static Widget getList({int conversation_id, Function builder}) {
    return api.query<Message>("""      
         query messages(\$conversation_id: ID!) {
          messages(conversation_id: \$conversation_id){
                id
                text
                createdAt
                type
                user{ 
                  id
                  firstname 
                  lastname 
                  avatar{ name bucketname token } 
                }
                attachment{ name bucketname token } 
              }
          }
          """, {'conversation_id': conversation_id},
        cache: false,
        onComplete: (dynamic data) =>
            ((data['messages'] ?? []) as List<dynamic>)
                .map((dynamic message) => Message.fromJson(message))
                .toList(),
        builder: builder);
  }

  static Widget onConversationMessage(
          {int conversation_id, Function builder, Function onCompleted}) =>
      api.subscription(
        operation: "onConversationMessage",
        query: """
          subscription onConversationMessage(\$conversation_id: ID!){
            onConversationMessage(conversation_id: \$conversation_id){
                 id
                text
                createdAt
                type
                conversation_id
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
        params: {'conversation_id': conversation_id},
        builder: builder,
      );

  static Widget onMessage({Function builder, Function onCompleted}) =>
      api.subscription(
        operation: "onMessage",
        query: """
          subscription onMessage{
            onMessage{
               id
                text
                createdAt
                conversation_id
                type
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
        builder: builder,
      );

  static api.Mutation send({Function builder, Function onCompleted}) =>
      api.mutation(query: """      
         mutation sendMessage(\$conversation_id: ID, \$users: [ID], \$text : String, \$name : String, \$attachment : FileInputDef) {
          sendMessage(conversation_id: \$conversation_id, users : \$users, text : \$text, name : \$name, attachment : \$attachment){
                conversation_id
              }
          }
          """, builder: builder, onCompleted: onCompleted);

  static Future<List<Message>> load(
      {int conversation_id, int offset, int count}) {
    return api.execute("""      
          query messages(\$conversation_id: ID!, \$count : Int,  \$offset : Int) {
          messages(conversation_id: \$conversation_id, count : \$count, offset : \$offset){
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
          """, {
      'conversation_id': conversation_id,
      'count': count,
      'offset': offset
    }, cache: false).then((dynamic data) {
      return (data['messages'] as List<dynamic>)
          .map((dynamic message) => Message.fromJson(message))
          .toList();
    });
  }

  static Widget getUnread({Function builder, BuildContext context}) {
    return api.query<Map<String, int>>("""    
             query unread{
                unread{
                MESSAGE
                GROUP
                CHANNEL
              }
            }
          """, {}, onComplete: (dynamic data) {
        unread = {
          'MESSAGE': data['unread']['MESSAGE'] as int,
          'GROUP': data['unread']['GROUP'] as int,
          'CHANNEL': data['unread']['CHANNEL'] as int
        };
      print([data, unread]);
      return unread;
    }, builder: builder);
  }
}
