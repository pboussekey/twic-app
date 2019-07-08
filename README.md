# Twic App

## Configuration

1) Run `flutter pub get` command to install dependencies
2) Update the **conf.env** file with API URL
3) Download **google-services.json** file from your firebase project (Parameters => Download last configuration file) and copy it and **android/app**.


## Structure

### Api

Contains services to communicate with the API

#### Models

Contains every models used by the application. Every model has to extends the AbstractModel class (providing serialization and comparison). The serialization system is based on [json_serializable](https://pub.flutter-io.cn/packages/json_serializable) package.

#### session.dart

Contains the user session in a singleton. 

```dart

import 'package:twic_app/api/session.dart';

[...]

await Session.init(); // Load session from disk;
Session session = Session.instance;

```

#### Services

Contains all services that build request for API.



##### api_rest.dart

Provide interface to send rest request to the API (for logged out features like login, ...).

##### api_graphql.dart

Based on [graphql-flutter](https://github.com/zino-app/graphql-flutter) package. 

 ##### abstract_service.dart

Class `ApiService<T>` to extends to easily build service to load and cache instances of a specific model.


###### Implementation

```dart
import 'package:twic_app/api/services/abstract_service.dart';

class MyModels extends ApiService<MyModel> {
  MyModels()
      : super(
            methodName: 'myModels', //API method to call
            queryParams: { // Method params with GraphQL types
              "bool_param": "Boolean",
              "string_param": "String",
              "fk_param": "ID",
              "int_param": "Int",
              "id": "[ID]" // Mandatory to get models by id
            },
            queryFields: """ //Field to retrieve from result
                id
                name
                nestedModel{ id name }
            """,
            map: (dynamic json) => MyModels.fromJson(json));
}
```

###### Usage

The service get models in 2 requests : 
- The first one to retrieve model's ids from params. The methods returns the id list.
- The second one to load models that are not already loaded from ids

Models are stored in a map called `list` indexed by id.
Once every models are loaded, the service call a callback.

 Generate a query widget :
  
```dart
import 'package:twic_app/api/services/mymodels.dart';
[...]
MyModels.getWidget(params: {'string_param':'string_param'}, onCompleted: (){
  //Your code
});

```

Load models outside widget tree :
  
```dart
import 'package:twic_app/api/services/mymodels.dart';
[...]
MyModels.getId(params: {'string_param':'string_param'}, onCompleted: (){
  setState((){});
}, builder : (List<int> ids) => ListView.builder(
     itemCount: users.length,
     itemBuilder: (BuildContext context, int index) => Text(MyModels.list[ids[index]]?.name)
   )
);

```

##### cache.dart

Register and manage every ApiService. Use this service rather than each ApiService individually.

 Get a model from cache :

```dart
import 'package:twic_app/api/services/cache.dart';

MyModel MyModel = AppCache.getModel<MyModel>(id);

```
Generate a query widget :

```dart
import 'package:twic_app/api/services/cache.dart';

[...]

AppCache.getWidget<MyModel>(
    params: {
      'string_param':'string_param'
    },
    onCompleted: (){
      setState((){});
    },
   builder : (List<int> ids) => ListView.builder(
     itemCount: users.length,
     itemBuilder: (BuildContext context, int index) => Text(AppCache.getModel<MyModel>(ids[index]])?.name)
   )
);

```

Load models outside widget tree :

```dart
import 'package:twic_app/api/services/cache.dart';

[...]

AppCache.getId<MyModel>(
        params: {
          'string_param':'string_param'
        },
        onCompleted: () {
            setState(() {});
        }).then((List<int> _models) {
      //Your code
    });
```

##### upload_service.dart

Upload a file calling a firebase function in the API.


  ###### Usage

```dart

import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/api/services/upload_service.dart' as upload_service;

[...]

upload_service.upload(file: file).then((Map<String, dynamic> fileData) {
     TwicFile attachment = TwicFile.fromJson(fileData);
});
```


### Pages

Contains all pages of the application.

#### root_page.dart

Widget to use for every page of the application for logged in users : 
1) Initialize the GraphQL Client to use it in the page
2) Structure the layout (AppBar, Scroll, Navigation Menu, ...)
3) Receive and handle chat messages and notification and update this layout 


 ###### Usage

```dart

import 'package:twic_app/pages/root_page.dart';

[...]

RootPage(
    appBar: AppBar(),
    child: Container(),
    scrollable: false, //The scroll will be handle in a child widget
    bottomBar: BottomNav(
      current: ButtonEnum.Home,
      refresh: setState,
    ));
 ```   
 
 
### Shared

Contains every components used in the application. 
Some are generics (BottomNav, Input, Autocomplete, ...) and some are related to a models (UserList, HashtagList, ...)
 
 
### Style

Contains the different texts style, colors and icons used in the application.
