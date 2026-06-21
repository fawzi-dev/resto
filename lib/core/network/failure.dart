sealed class Failure implements Exception {
  const Failure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error', this.statusCode]);
  final int? statusCode;
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong']);
}
