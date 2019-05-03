
import 'package:graphql_flutter/graphql_flutter.dart';

class AppCache {

  static Cache instance;

  static Cache get() {
    if(null == instance){
      instance = InMemoryCache();
    }
    return instance;
  }
}