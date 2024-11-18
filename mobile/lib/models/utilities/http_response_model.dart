class HttpResponse<T> {
  final int statusCode;
  final String reasonPhrase;
  final T body;

  const HttpResponse({required this.statusCode, required this.reasonPhrase, required this.body});
}
