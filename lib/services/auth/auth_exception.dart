// Login Exceptions

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//Register Exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//Generin Exception

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
