import 'package:twic_app/api/services/api_graphql.dart' as api;
import 'package:twic_app/api/models/models.dart';

import 'package:twic_app/api/services/abstract_service.dart';

export 'package:twic_app/api/services/api_graphql.dart';

class Conversations extends ApiService<Conversation> {
  Conversations()
      : super(
      methodName: 'conversations',
      queryParams: {
        "type": "String",
        "search": "String",
        "id" : "[ID]"
      },
      queryFields: """
               id 
                  name 
                  last 
                  lastDate  
                  lastId
                  unread
                  type
                  users{id firstname lastname avatar{ name bucketname token }}
                  hashtag{id name nbFollowers}
                  picture{ name bucketname token }
            """,
      map: (dynamic json) => Conversation.fromJson(json));


  static api.Mutation create({Function builder, Function onCompleted, Function update}) => api.mutation(query: """      
         mutation addConversation(\$name: String, \$picture : FileInputDef,  \$users : [ID]) {
          addConversation(name: \$name, picture: \$picture, users: \$users){
                id 
                name 
                last 
                lastDate  
                lastId
                unread
                type
                users{id firstname lastname avatar{ name bucketname token }}
                picture{ name bucketname token }
                hashtag{id name nbFollowers}
            }
          }
          """, builder: builder, onCompleted: onCompleted, update: update);

  static api.Mutation createChannel({Function builder, Function onCompleted, Function update}) => api.mutation(query: """      
         mutation createChannel(\$name: String) {
          createChannel(name: \$name){
                id 
                name 
                last 
                lastDate  
                lastId
                unread
                type
                picture{ name bucketname token }
                hashtag{id name nbFollowers}
            }
          }
          """, builder: builder, onCompleted: onCompleted, update: update);

  static api.Mutation join({Function builder, Function onCompleted, Function update}) => api.mutation(query: """      
         mutation joinChannel( \$hashtag_id : ID) {
          joinChannel( hashtag_id: \$hashtag_id){
                id 
                name 
                last 
                lastDate 
                lastId
                unread 
                type
                hashtag{id name nbFollowers}
                picture{ name bucketname token }
            }
          }
          """, builder: builder, onCompleted: onCompleted, update: update);




  static void read(int conversation_id){
    api.execute("""      
         mutation readConversation( \$id : ID) {
          readConversation( id: \$id){
                success
            }
          }
          """, { "id" : conversation_id});
  }



}
