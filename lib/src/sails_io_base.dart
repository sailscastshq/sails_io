import 'package:socket_io_client/socket_io_client.dart' as socket_io;

typedef Json = Map<String, dynamic>;
typedef JWRCallBack = void Function(dynamic body, JWR jwr);

class SailsIOClient {
  late socket_io.Socket socket;
  Json? headers;

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
        cb(responseContext['body'], JWR.fromJSON(responseContext));
      }
    });
  }

  /// Simulate an HTTP request to sails
  void request(RequestOptions options, JWRCallBack? cb) {
    options.headers = options.headers ?? {};
    if (options.data != null && options.params != null) {
      options.params = options.data;
      options.data = null;
    }

    // Merge global headers in, if there are any
    if (headers != null && headers!.isNotEmpty) {
      options.headers = {...options.headers!, ...headers!};
    }

    var requestContext = <String, dynamic>{
      'method': (options.method ?? 'get').toLowerCase(),
      'headers': options.headers,
      'data': options.params ?? options.data ?? {},
      'url': options.url?.trim(),
      'cb': cb
    };
    _emitFrom(socket, requestContext);
  }

  /// Simulate a GET request to sails
  void get({required String url, Json? headers, Json? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJSON(
          {'method': 'get', 'url': url, 'headers': headers, 'params': data},
        ),
        cb);
  }

  /// Simulate a POST request to sails
  void post({required String url, Json? headers, Json? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJSON(
          {'method': 'post', 'url': url, 'headers': headers, 'params': data},
        ),
        cb);
  }

  /// Simulate a PUT request to sails
  void put({required String url, Json? headers, Json? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJSON(
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
        RequestOptions.fromJSON(
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
        RequestOptions.fromJSON(
          {'method': 'delete', 'url': url, 'headers': headers, 'params': data},
        ),
        cb);
  }
}

class RequestOptions {
  String? url;
  Json? params;
  Json? data;
  Json? headers;
  String? method;

  RequestOptions({url, params, data, headers, method});

  RequestOptions.fromJSON(Json payload) {
    url = payload['url'];
    params = payload['params'];
    headers = payload['headers'];
    method = payload['method'];
  }
}

class JWR {
  dynamic body;
  Json? headers;
  late int statusCode;
  JWR.fromJSON(Json responseContext) {
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
