class TokenResponse {
  final String token;

  const TokenResponse({
    this.token
  });

  factory TokenResponse.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    return TokenResponse(
      token: data['token']
    );
  }
}