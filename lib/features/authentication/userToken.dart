import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserName {
  static Future<String?> buildUserNameWidget() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fetch the current user's email
    final currentUserEmail = _firebaseAuth.currentUser?.email;

    // Check if the username is already cached for this user
    final cachedUserName = prefs.getString(currentUserEmail ?? '');
    if (cachedUserName != null) {
      return cachedUserName;
    }

    // Fetch the username from Firestore
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    print("Tokennn:{googleSignInAuthentication.idToken}");
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    final User? user = userCredential.user;
    String? userName = user!.displayName;

    // Cache the username for this user
    await prefs.setString(currentUserEmail ?? '', userName!);

    return userName;
  }
}
