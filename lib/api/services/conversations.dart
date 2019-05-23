import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';
import 'package:flutter/material.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Conversations {
  static Widget getList({Function builder}) =>
      api.query<Conversation>(
          query:
          """query conversations{
               conversations{
                  id 
                  name 
                  last 
                  lastDate  
                  users{id firstname lastname avatar{ name bucketname token }}
                  picture{ name bucketname token }
                  
              }}""",
          cache: false,
          onComplete: (dynamic data) =>
              (data['conversations'] as List<dynamic>)
                  .map((dynamic conversation) =>
                  Conversation.fromJson(conversation))
                  .toList(),
          builder: builder);



  static api.Mutation create({Function builder, Function onCompleted, Function update}) => api.mutation(query: """      
         mutation addConversation(\$name: String, \$picture : FileInputDef,  \$users : [ID]) {
          addConversation(name: \$name, picture: \$picture, users: \$users){
                id 
                name 
                last 
                lastDate  
                users{id firstname lastname avatar{ name bucketname token }}
                picture{ name bucketname token }
            }
          }
          """, builder: builder, onCompleted: onCompleted, update: update);



}
