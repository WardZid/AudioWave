
abstract class AuthRepository {
  Future<String> getPublicKey();
  Future<bool> signIn(String email, String password);
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<bool> register(String email, String username, String password, String firstName, String lastName);
  Future<bool> checkUsername(String username);
  Future<bool> checkEmail(String email);
}
