// Code returns by zero server in a response
enum ResponseCode { CODE_OK, CODE_KO }

// Response from zero server
class Response {
  final String msg;
  final Map<String, dynamic> data;
  final ResponseCode code;

  Response({this.msg, this.data, this.code});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
        msg: json['msg'],
        data: json['data'],
        code: ResponseCode.values.firstWhere(
            (e) => e.toString() == ("ResponseCode." + json['code'])));
  }
}
