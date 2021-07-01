import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class SailsIOClient {
  late socket_io.Socket socket;
  SailsIOClient(socket_io.Socket socketIOClient) {
    socket = socketIOClient;
  }

  void _emitFrom(socket_io.Socket socket, Map<String, dynamic> requestCtx) {
    JWRCallBack cb = requestCtx['cb'];

    requestCtx.remove('cb');
    String sailsEndpoint = requestCtx['method'];

    socket.emitWithAck(sailsEndpoint, requestCtx, ack: (dynamic responseCtx) {
      // ignore: unnecessary_null_comparison
      if (cb != null && requestCtx['calledCb'] != null) {
        cb(responseCtx['body'], JWR.fromJSON(responseCtx));
        requestCtx['calledCb'] = true;
      }
    });
  }

  void request(RequestOptions options, JWRCallBack cb) {
    options.headers = options.headers ?? {};

    if (options.data != null && options.params != null) {
      options.params = options.data;
      options.data = null;
    }
    var requestCtx = <String, dynamic>{
      'method': (options.method ?? 'get').toLowerCase(),
      'headers': options.headers,
      'data': options.params ?? options.data ?? {},
      'url': options.url?.trim(),
      'cb': cb
    };
    _emitFrom(socket, requestCtx);
  }

  void get({required String url, Map<String, dynamic>? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJSON(
          {'method': 'get', 'url': url, 'params': data ?? {}},
        ),
        cb!);
  }

  void post(
      {required String url, Map<String, dynamic>? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJSON(
          {'method': 'post', 'url': url, 'params': data ?? {}},
        ),
        cb!);
  }

  void put({required String url, Map<String, dynamic>? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJSON(
          {'method': 'put', 'url': url, 'params': data ?? {}},
        ),
        cb!);
  }

  void patch(
      {required String url, Map<String, dynamic>? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJSON(
          {'method': 'put', 'url': url, 'params': data ?? {}},
        ),
        cb!);
  }

  void delete(
      {required String url, Map<String, dynamic>? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJSON(
          {'method': 'delete', 'url': url, 'params': data ?? {}},
        ),
        cb!);
  }
}

typedef JWRCallBack = void Function(Map<String, dynamic> body, JWR jwr);

class RequestOptions {
  String? url;
  Map<dynamic, dynamic>? params;
  Map<dynamic, dynamic>? data;
  Map<dynamic, dynamic>? headers;
  String? method;

  RequestOptions({url, params, data, headers, method});
  RequestOptions.fromJSON(Map<String, dynamic> payload) {
    url = payload['url'];
    params = payload['params'];
    headers = payload['headers'];
    method = payload['method'];
  }
}

class JWR {
  dynamic body;
  dynamic headers;
  int? statusCode;
  JWR.fromJSON(Map<String, dynamic> responseCtx) {
    body = responseCtx['body'];
    headers = responseCtx['headers'] ?? {};
    statusCode = responseCtx['statusCode'] ?? 200;
  }
  @override
  String toString() {
    return '[ResponseFromSails] -- Status: $statusCode -- Headers $headers -- Body $body ';
  }

  Map<String, dynamic> toJSON() {
    var data = <String, dynamic>{};
    data['body'] = body;
    data['headers'] = headers;
    data['statusCode'] = statusCode;
    return data;
  }
}
