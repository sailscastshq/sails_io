import 'package:socket_io_client/socket_io_client.dart' as socket_io;

typedef Json = Map<String, dynamic>;
typedef JWRCallBack = void Function(dynamic body, JWR jwr);

class SailsIOClient {
  late socket_io.Socket socket;
  Json? headers;

  SailsIOClient(socket_io.Socket socketIOClient) {
    socket = socketIOClient;
  }

  // Set global headers for the SailsIOClient instance
  set setHeaders(Json? value) => headers = value;

  void _emitFrom(socket_io.Socket socket, Json requestCtx) {
    JWRCallBack? cb = requestCtx.remove('cb');

    String sailsEndpoint = requestCtx['method'];

    socket.emitWithAck(sailsEndpoint, requestCtx, ack: (Json responseCtx) {
      if (cb != null) {
        cb(responseCtx['body'], JWR.fromJSON(responseCtx));
        requestCtx['calledCb'] = true;
      }
    });
  }

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

    var requestCtx = <String, dynamic>{
      'method': (options.method ?? 'get').toLowerCase(),
      'headers': options.headers,
      'data': options.params ?? options.data ?? {},
      'url': options.url?.trim(),
      'cb': cb
    };
    _emitFrom(socket, requestCtx);
  }

  void get({required String url, Json? headers, Json? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJSON(
          {'method': 'get', 'url': url, 'headers': headers, 'params': data},
        ),
        cb!);
  }

  void post({required String url, Json? headers, Json? data, JWRCallBack? cb}) {
    return request(
        RequestOptions.fromJSON(
          {'method': 'post', 'url': url, 'headers': headers, 'params': data},
        ),
        cb);
  }

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
  dynamic headers;
  int? statusCode;
  JWR.fromJSON(Json responseCtx) {
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
