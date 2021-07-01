Dart/Flutter Client SDK for communication with Sails from a mobile application(or any client running Dart or Flutter)



## Usage

A simple usage example:

```dart
import 'package:sails_io/sails_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io_client;

void main() {
  var io = SailsIOClient(socket_io_client.io(
      'http://example_websocket_url.com',
      socket_io_client.OptionBuilder().setTransports(['websocket']).build()));

  io.socket.onConnect((_) {
    print('Connected');
  });

  io.socket.on('user', (message) {});
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

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/sailscastshq/sails_io/issues
