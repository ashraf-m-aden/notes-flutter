//// create user

class UserNotLoggedInAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// login user

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// generic exception
class GenericAuthException implements Exception {}
