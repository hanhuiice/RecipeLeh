import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_leh/models/username.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebased user
  userName? _fromFirebaseUser(User user)
  {
  return user != null ? userName (uid: user.uid) : null;
  }


  // Login Anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _fromFirebaseUser(user!);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

// sign in with email and password


// register with email and password

// sign out

}