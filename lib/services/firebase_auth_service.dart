import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class FirebaseAuthService {
  static FirebaseAuthService? _instance;
  static FirebaseAuthService get instance => _instance ??= FirebaseAuthService._();
  
  FirebaseAuthService._();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Register parent account
  Future<UserModel?> registerParent({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create Firebase user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = credential.user;
      if (user == null) throw Exception('Failed to create user');
      
      // Update display name
      await user.updateDisplayName(name);
      
      // Create user document in Firestore
      final userModel = UserModel(
        id: user.uid,
        name: name,
        email: email,
        userType: UserType.parent,
        childIds: const [],
        createdAt: DateTime.now(),
        isActive: true,
        preferences: const {},
      );
      
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());
      
      // Set analytics user properties
      await FirebaseService.instance.setUserProperties(
        userId: user.uid,
        userType: 'parent',
      );
      
      // Sign out the user so they need to sign in manually
      await _auth.signOut();
      
      return userModel;
    } catch (e) {
      print('Parent registration failed: $e');
      rethrow;
    }
  }
  
  // Create child account (called by parent)
  Future<UserModel?> createChildAccount({
    required String childName,
    required int age,
    required String parentId,
    required String deviceId,
  }) async {
    try {
      // Generate child email and password
      final childEmail = '${childName.toLowerCase().replaceAll(' ', '')}_${DateTime.now().millisecondsSinceEpoch}@familyguard.child';
      final childPassword = 'child_${DateTime.now().millisecondsSinceEpoch}';
      
      // Create Firebase user for child
      final credential = await _auth.createUserWithEmailAndPassword(
        email: childEmail,
        password: childPassword,
      );
      
      final user = credential.user;
      if (user == null) throw Exception('Failed to create child user');
      
      // Update display name
      await user.updateDisplayName(childName);
      
      // Create child user document in Firestore
      final childModel = UserModel(
        id: user.uid,
        name: childName,
        email: childEmail,
        userType: UserType.child,
        parentId: parentId,
        childIds: const [],
        createdAt: DateTime.now(),
        isActive: true,
        preferences: const {},
        age: age,
        deviceId: deviceId,
      );
      
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(childModel.toJson());
      
      // Update parent's child list
      await _firestore
          .collection('users')
          .doc(parentId)
          .update({
        'childIds': FieldValue.arrayUnion([user.uid]),
      });
      
      // Set analytics user properties
      await FirebaseService.instance.setUserProperties(
        userId: user.uid,
        userType: 'child',
        parentId: parentId,
      );
      
      return childModel;
    } catch (e) {
      print('Child account creation failed: $e');
      rethrow;
    }
  }
  
  // Login
  Future<UserModel?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = credential.user;
      if (user == null) throw Exception('Login failed');
      
      // Get user data from Firestore
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (!doc.exists) throw Exception('User data not found');
      
      final userModel = UserModel.fromJson(doc.data()!);
      
      // Set analytics user properties
      await FirebaseService.instance.setUserProperties(
        userId: user.uid,
        userType: userModel.userType.name,
        parentId: userModel.parentId,
      );
      
      return userModel;
    } catch (e) {
      print('Login failed: $e');
      rethrow;
    }
  }
  
  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Logout failed: $e');
      rethrow;
    }
  }
  
  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      
      if (!doc.exists) return null;
      
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      print('Failed to get user: $e');
      return null;
    }
  }
  
  // Get children for parent
  Future<List<UserModel>> getChildrenForParent(String parentId) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('parentId', isEqualTo: parentId)
          .where('userType', isEqualTo: 'child')
          .get();
      
      return query.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Failed to get children: $e');
      return [];
    }
  }
  
  // Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update(updates);
    } catch (e) {
      print('Failed to update user profile: $e');
      rethrow;
    }
  }
  
  // Delete user account
  Future<void> deleteUser(String userId) async {
    try {
      // Delete user document from Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .delete();
      
      // Delete Firebase Auth user
      final user = _auth.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
      }
    } catch (e) {
      print('Failed to delete user: $e');
      rethrow;
    }
  }
  
  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Failed to send password reset email: $e');
      rethrow;
    }
  }
  
  // Google Sign-In
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      
      if (user == null) throw Exception('Failed to sign in with Google');
      
      // Check if user already exists in Firestore
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (doc.exists) {
        // User exists, return existing user data
        final userModel = UserModel.fromJson(doc.data()!);
        
        // Set analytics user properties
        await FirebaseService.instance.setUserProperties(
          userId: user.uid,
          userType: userModel.userType.name,
          parentId: userModel.parentId,
        );
        
        return userModel;
      } else {
        // New user, create user document
        final userModel = UserModel(
          id: user.uid,
          name: user.displayName ?? 'Google User',
          email: user.email ?? '',
          profileImage: user.photoURL,
          userType: UserType.parent, // Default to parent for Google sign-in
          childIds: const [],
          createdAt: DateTime.now(),
          isActive: true,
          preferences: const {},
        );
        
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());
        
        // Set analytics user properties
        await FirebaseService.instance.setUserProperties(
          userId: user.uid,
          userType: 'parent',
        );
        
        return userModel;
      }
    } catch (e) {
      print('Google Sign-In failed: $e');
      rethrow;
    }
  }
  
  // Sign out from Google
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Failed to sign out from Google: $e');
    }
  }
}
