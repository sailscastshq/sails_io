import 'package:sails_io/sails_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io_client;

main() {
  SailsIOClient io = SailsIOClient(
    SocketIOClient.io(
      'http://example_websocket_url.com',
      SocketIOClient.OptionBuilder().setTransports(['websocket']).build()
      )
    );

    io.socket.onConnect((_) {
      print('Connected');
    });

    io.socket.on('user', (message) {});
    io.socket.onDisconnect((_) => print('disconnected'))

    io.post('http://example_websocket_url.com/chats',
    {'textContent': 'New chat from sails_io', 'counterpartId': '464684932623463467'},
    (body, jwrResponse) {
      print(body);
      print(jwrResponse.toJSON());
    })
}
