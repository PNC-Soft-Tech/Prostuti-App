class CustomError {
  final String message;
  final int? code;
  final String? source;

  // The first positional arg is the HTTP status code from the response. The
  // codebase passes it positionally (e.g. `CustomError(response.statusCode,
  // message: ...)`), so we assign it to `code` here. Previously it was silently
  // discarded, leaving every error with `code == null`.
  CustomError(int? statusCode, {
    required this.message,
    int? code,
    this.source,
  }) : code = code ?? statusCode;

  @override
  String toString() {
    return 'CustomError: $message (code: $code, source: $source)';
  }
}
