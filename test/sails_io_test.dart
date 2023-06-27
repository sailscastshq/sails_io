import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sails_io/sails_io.dart';
import 'package:test/test.dart';
import 'dart:async';

// Work in progress...SNM

void main() {
  // Create an instance of SailsIOClient
  late SailsIOClient sailsIOClient;

  // Set up the test case
  setUp(() {
    // Create a mock SocketIOClient
    final mockSocket = io.io(
        'http://localhost:1337',
        io.OptionBuilder().setTransports(['websocket'])
            // .disableAutoConnect()
            .build());

    // Initialize SailsIOClient with the mock socket
    sailsIOClient = SailsIOClient(mockSocket);

    // socket.connect();

    sailsIOClient.socket.onConnect((_) {
      sailsIOClient.socket.emit('toServer', 'init');

      var count = 0;
      Timer.periodic(const Duration(seconds: 1), (Timer countDownTimer) {
        sailsIOClient.socket.emit('toServer', count++);
      });
    });

    sailsIOClient.socket.on('event', (data) => print(data));
    sailsIOClient.socket.on('disconnect', (_) => print('disconnect'));
    sailsIOClient.socket.on('fromServer', (_) => print(_));
  });

  // Define your test cases
  test('GET request should be simulated', () {
    // Create a mock callback function
    void mockCallback(dynamic body, JWR jwr) {
      // Assert the response body or any other expectations
      expect(body, isNotNull);
      expect(jwr.statusCode, equals(200));
    }

    // Simulate a GET request using SailsIOClient
    sailsIOClient.get(
      url: 'https://example.com',
      headers: {'Content-Type': 'application/json'},
      cb: mockCallback,
    );
  });

  // Add more test cases for other methods if needed
}
