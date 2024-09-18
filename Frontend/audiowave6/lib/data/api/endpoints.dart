class Endpoints {
  static const String baseUrl = 'http://10.0.0.13/api';

  // AuthService Endpoints
  static const String usersAuthUrl = '$baseUrl/users/auth';
  static const String registerEncryptedUrl = '$baseUrl/users/auth/register-encrypted';
  static const String registerUrl = '$baseUrl/users/auth/register';
  static const String loginEncryptedUrl = '$baseUrl/users/auth/login-encrypted';
  static const String loginUrl = '$baseUrl/users/auth/login';
  static const String publicKeyUrl = '$baseUrl/users/auth/public-key';
  static const String checkUsernameUrl = '$baseUrl/users/auth/check-username';
  static const String checkEmailUrl = '$baseUrl/users/auth/check-email';

  // MetadataService Endpoints
  static const String audioMetadataUrl = '$baseUrl/metadata/audio';

  // AudioFileService Endpoints
  static const String uploadAudioUrl = '$baseUrl/audio/upload';
  static const String playbackAudioUrl = '$baseUrl/audio/playback';

  //PlaylistService Endpoints
  static const String playlistUrl = '$baseUrl/playlist';
}
