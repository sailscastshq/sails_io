Dart/Flutter Websocket Client SDK for communication with Sails from a mobile application(or any client running Dart or Flutter)



## Usage

A simple usage example:

```dart
import 'package:sails_io/sails_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io_client;

void main() {
  var io = SailsIOClient(socket_io_client.io(
      'http://example_websocket_url.com?__sails_io_sdk_version=0.11.0',
      socket_io_client.OptionBuilder().setTransports(['websocket']).build()));

  io.socket.onConnect((_) {
    print('Connected');
  });

  // Subscribe to updates of user entity creating a get action:
  // https://sailsjs.com/documentation/reference/web-sockets/resourceful-pub-sub/subscribe
  io.get(
      url: "http://example_websocket_url.com/user-subs",
      cb: (body, jwrResponse) {
        print(body);
        print(jwrResponse.toJson());
      });
      
  io.socket.on('user', (message) {
    // You'll get events on publish
    // https://sailsjs.com/documentation/reference/web-sockets/resourceful-pub-sub/publish
  });
  io.socket.onDisconnect((_) => print('disconnected'));

  io.post(
      url: 'http://example_websocket_url.com/chats',
      data: {
        'textContent': 'New chat from sails_io',
        'counterpartId': '464684932623463467'
      },
      cb: (body, jwrResponse) {
        print(body);
        print(jwrResponse.toJSON());
      });
}
```
## The __sails_io_sdk_version query string
Currently, the Sails websocket server expects that the socket client connecting with it is >= 0.11.0 or it will default to a version of 0.9.0.

To override this notice we are passing the query string to the URL when connecting like so

```dart
 var io = SailsIOClient(socket_io_client.io(
      'http://example_websocket_url.com?__sails_io_sdk_version=0.11.0',
      socket_io_client.OptionBuilder().setTransports(['websocket']).build()));
```

Do note that this is important because even if your socket connects without the string, trying to listen or use the virtual requests i.e `io.post` or `io.get` will result in an error on your Sails server saying the version of the SDK is incompatible
## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/sailscastshq/sails_io/issues
