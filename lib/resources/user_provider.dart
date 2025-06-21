import 'package:only_vocal/models/user.dart';
import 'package:only_vocal/resources/auth_methods.dart';
import 'package:flutter/material.dart';

// class UserProvider with ChangeNotifier {
//   User? _user;
//   final AuthMethods _authMethods = AuthMethods();

//   // Getter for user
//   User? get getUser => _user;

//   Future<void> refreshUser([User? updatedUser]) async {
//     if (updatedUser != null) {
//       // If user object is provided, use it directly
//       _user = updatedUser;
//     } else {
//       // If no user object provided, fetch from AuthMethods
//       _user = await _authMethods.getUserDetails();
//     }
//     notifyListeners();
//   }

//   // Method to refresh user from AuthMethods
//   Future<void> refreshUserFromAuth() async {
//     User user = await _authMethods.getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  // Getter for user
  User? get getUser => _user;

  Future<void> refreshUser([User? updatedUser]) async {
    if (updatedUser != null) {
      // If user object is provided, use it directly
      _user = updatedUser;
    } else {
      // If no user object provided, fetch from AuthMethods
      _user = await _authMethods.getUserDetails();
    }
    notifyListeners();
  }

  // Method to refresh user from AuthMethods
  Future<void> refreshUserFromAuth() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  void updateRatingAndReview({String? rating, String? review}) {
  if (_user != null) {
    _user = User(
      username: _user!.username,
      email: _user!.email,
      uid: _user!.uid,
      rating: rating ?? _user!.rating,
      review: review ?? _user!.review,
    );
    notifyListeners();
  }
}

}