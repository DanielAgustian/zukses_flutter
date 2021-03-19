// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:zukses_app_1/model/auth-model.dart';
// import 'package:zukses_app_1/model/user-model.dart';

class AuthenticationRepository {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   Future<AuthModel> signInWithGoogle() async {
//     GoogleSignInAccount googleSignInAccount;
//     try {
//       print("jalan");
//       googleSignInAccount = await _googleSignIn.signIn();

//       // user canceled the sign-in.
//       if (googleSignInAccount == null) {
//         return null;
//       }

//       GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;

//       AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       UserCredential authResult =
//           await _firebaseAuth.signInWithCredential(credential);
//       User user = authResult.user;

//       if (user != null) {
//         assert(!user.isAnonymous);
//         assert(await user.getIdToken() != null);

//         final User currentUser = _firebaseAuth.currentUser;
//         assert(user.uid == currentUser.uid);

//         AuthModel userModel = AuthModel(
//           // It should be get token after Login
//           token: "",
//           user: UserModel(
//             userID: user.uid,
//             email: user.email,
//             name: user.displayName,
//             imgUrl: user.photoURL,
//           ),
//         );
//         print('signInWithGoogle succeeded: $user');

//         return userModel;
//       }

//       return null;
//     } on PlatformException catch (e) {
//       print('PlatformException error');
//       print(e);
//     } catch (e, s) {
//       print('Google Sign-In error');
//       print(e);
//       print(s);
//     }
//   }
}
