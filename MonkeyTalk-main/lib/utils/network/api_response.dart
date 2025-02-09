class APIResponse<T> {
  late final String message;
  final dynamic data;
  final int? statusCode;

  factory APIResponse.fromJson(dynamic jsonResponse, int? statusCode) {
    return APIResponse(
      data: jsonResponse,
      statusCode: statusCode,
    );
  }

  APIResponse({
    this.data,
    this.statusCode,
  });

  @override
  String toString() {
    return 'APIResponse{message: $message, data: $data}';
  }
}
