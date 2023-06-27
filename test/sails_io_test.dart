import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:sails_io/sails_io.dart';
import 'package:socket_io_common/src/util/event_emitter.dart';
import 'package:socket_io_client/src/manager.dart';
import 'package:test/test.dart';

// Work in progress...SNM

void main() {
  // Create an instance of SailsIOClient
  late SailsIOClient sailsIOClient;

  // Set up the test case
  setUp(() {
    // Create a mock SocketIOClient
    final mockSocket = MockSocketIOClient();

    // Initialize SailsIOClient with the mock socket
    sailsIOClient = SailsIOClient(mockSocket);
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

// Define a mock class for SocketIOClient
class MockSocketIOClient implements socket_io.Socket {
  // late final String id;
  final Map<String, List<Function>> eventListeners = {};

  @override
  Future<void> onconnect(id) async {
    // Implement the connect method behavior for the mock client
    // For example, you can set the `id` property to a unique identifier
    id = 'mock-socket-id';
  }

  @override
  Future<void> ondisconnect() async {
    // Implement the disconnect method behavior for the mock client
    // For example, you can clear all registered event listeners
    eventListeners.clear();
  }

  @override
  void on(String event, Function callback) {
    // Implement the on method behavior for the mock client
    // Add the callback function to the list of event listeners for the specified event
    if (eventListeners.containsKey(event)) {
      eventListeners[event]!.add(callback);
    } else {
      eventListeners[event] = [callback];
    }
  }

  @override
  void emit(String event, [dynamic data]) {
    // Implement the emit method behavior for the mock client
    // Invoke all the event listeners registered for the specified event
    if (eventListeners.containsKey(event)) {
      for (final callback in eventListeners[event]!) {
        callback(data);
      }
    }
  }

  @override
  Map acks = {};

  @override
  var auth;

  @override
  bool connected = false;

  @override
  bool disconnected = true;

  @override
  Map flags = {};

  @override
  num ids = 0;

  @override
  late Manager io;

  @override
  late socket_io.Socket json;

  @override
  String nsp = '';

  @override
  Map? opts;

  @override
  String? query;

  @override
  List receiveBuffer = [];

  @override
  List sendBuffer = [];

  @override
  List? subs;

  @override
  Function ack(id) {
    throw UnimplementedError();
  }

  @override
  bool get active => false;

  @override
  void clearListeners() {
    eventListeners.clear();
  }

  @override
  socket_io.Socket close() {
    throw UnimplementedError();
  }

  @override
  socket_io.Socket compress(compress) {
    throw UnimplementedError();
  }

  @override
  void destroy() {}

  @override
  void dispose() {}

  @override
  void emitBuffered() {}

  @override
  void emitWithAck(String event, data, {Function? ack, bool binary = false}) {}

  @override
  bool hasListeners(String event) {
    throw UnimplementedError();
  }

  @override
  void off(String event, [EventHandler? handler]) {}

  @override
  void offAny([AnyEventHandler? handler]) {}

  @override
  void onAny(AnyEventHandler handler) {}

  @override
  void onack(Map packet) {}

  @override
  void once(String event, EventHandler handler) {}

  @override
  void onclose(reason) {}

  // @override
  // void onconnect(id) {}

  // @override
  // void ondisconnect() {}

  @override
  void onerror(err) {}

  @override
  void onevent(Map packet) {}

  @override
  void onopen([_]) {}

  @override
  void onpacket(packet) {}

  @override
  socket_io.Socket open() {
    throw UnimplementedError();
  }

  @override
  void packet(Map packet) {}

  @override
  socket_io.Socket send(List args) {
    throw UnimplementedError();
  }

  @override
  void subEvents() {}

  @override
  String? id;

  @override
  socket_io.Socket connect() {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  socket_io.Socket disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }
}
