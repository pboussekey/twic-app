import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/api/services/api_graphql.dart' as api;

export 'package:twic_app/api/services/api_graphql.dart';

class Notifications {
  static bool hasNotification = false;
  static Future<List<TwicNotification>> load({int count, int page}) {
    return api.execute("""      
         query notifications(\$count : Int,  \$page : Int) {
            notifications(count : \$count, page : \$page){
               id
                type
                text
                count
                createdAt
                user{ 
                  id
                  firstname 
                  lastname 
                  avatar{ name bucketname token } 
                }
             }
          }
          """, {'count': count, 'page': page},
        cache: false).then((dynamic data) {
          print(["DATA", data]);
      return (data['notifications'] as List<dynamic>)
          .map(
              (dynamic notification) => TwicNotification.fromJson(notification))
          .toList();
    });
  }
}
