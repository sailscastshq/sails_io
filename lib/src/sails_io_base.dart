import 'package:socket_io_client/socket_io_client.dart' as socket_io;

typedef Json = Map<String, dynamic>;
typedef JWRCallBack = void Function(dynamic body, JWR jwr);

class SailsIOClient {
  late final socket_io.Socket socket;
  Json headers = {};

  SailsIOClient(socket_io.Socket socketIOClient) {
    socket = socketIOClient;
  }

  /// Set global headers for the SailsIOClient instance
  set setHeaders(Json value) => headers = value;

  void _emitFrom(socket_io.Socket socket, Json requestContext) {
    JWRCallBack? cb = requestContext.remove('cb');
    socket.emitWithAck(requestContext['method'], requestContext,
        ack: (Json responseContext) {
      if (cb != null) {
        cb(responseContext['body'], JWR.fromJson(responseContext));
      }
    });
  }

  /// Simulate an HTTP request to sails
  void request(RequestOptions options, JWRCallBack? cb) {
    options.headers = options.headers;
    // Merge global headers in, if there are any

    options.headers = {...options.headers, ...headers};

    var requestContext = <String, dynamic>{
      'method': options.method.toLowerCase(),
      'headers': options.headers,
      'data': options.params,
      'url': options.url.trim(),
      'cb': cb
    };
    _emitFrom(socket, requestContext);
  }

  /// Simulate a GET request to sails
  void get({required String url, Json? headers, Json? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJson(
          {'method': 'get', 'url': url, 'headers': headers, 'params': data},
        ),
        cb);
  }

  /// Simulate a POST request to sails
  void post({required String url, Json? headers, Json? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJson(
          {'method': 'post', 'url': url, 'headers': headers, 'params': data},
        ),
        cb);
  }

  /// Simulate a PUT request to sails
  void put({required String url, Json? headers, Json? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJson(
          {
            'method': 'put',
            'url': url,
            'headers': headers,
            'params': data,
          },
        ),
        cb);
  }

  /// Simulate a PATCH request to sails
  void patch(
      {required String url, Json? headers, Json? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJson(
          {
            'method': 'patch',
            'url': url,
            'headers': headers,
            'params': data,
          },
        ),
        cb);
  }

  /// Simulate a DELETE request to sails
  void delete(
      {required String url, Json? headers, Json? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJson(
          {'method': 'delete', 'url': url, 'headers': headers, 'params': data},
        ),
        cb);
  }
}

class RequestOptions {
  String url = '';
  Json params = {};
  Json headers = {};
  String method = 'get';

  RequestOptions({required url, params, data, headers, method});

  RequestOptions.fromJson(Json payload) {
    assert(payload['url'] != null);
    url = payload['url'];
    if (payload['params'] != null) {
      params = payload['params'];
    }
    if (payload['headers'] != null) {
      headers = payload['headers'];
    }
    if (payload['method'] != null) {
      method = payload['method'];
    }
  }
}

class JWR {
  dynamic body;
  Json headers = {};
  int statusCode = 200;

  JWR({body, headers, statusCode});

  JWR.fromJson(Json responseContext) {
    body = responseContext['body'];
    headers = responseContext['headers'] ?? {};
    statusCode = responseContext['statusCode'] ?? 200;
  }

  @override
  String toString() {
    return '[ResponseFromSails] -- Status: $statusCode -- Headers $headers -- Body $body ';
  }

  Json toJson() {
    var data = <String, dynamic>{};
    data['body'] = body;
    data['headers'] = headers;
    data['statusCode'] = statusCode;
    return data;
  }
}
