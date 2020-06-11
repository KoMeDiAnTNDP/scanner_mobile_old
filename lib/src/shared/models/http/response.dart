class ResponseWithError<TResponse> {
  final String errorMessage;
  final TResponse response;

  const ResponseWithError({
    this.response,
    this.errorMessage
  });
}