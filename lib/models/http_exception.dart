class HttpException implements Exception {
  String message = "Http Exception Occoured";

  HttpException({this.message});

  @override
  String toString() {
    return this.message;
  }

}