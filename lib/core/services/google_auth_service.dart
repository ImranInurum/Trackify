import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final GoogleAuthService instance = GoogleAuthService._();
  GoogleAuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static const String _webClientId = '248560151060-ohj6dcjrseubkce2sgtrmsij0e8vd5fd.apps.googleusercontent.com';

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: _webClientId,
      );

      final GoogleSignInAccount user = await _googleSignIn.authenticate();
      GoogleSignInAuthentication? authentication = user.authentication;

      final credentials = GoogleAuthProvider.credential(idToken: authentication.idToken);

      return await _auth.signInWithCredential(credentials);
    } catch (error) {
      print("Google Auth Error: $error");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
