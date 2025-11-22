import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Ritorna true se la biometria va a buon fine altrimenti false.
  Future<bool> authenticateBiometrics() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        return false;
      }

      final didAuth = await _localAuth.authenticate(
        localizedReason: 'Authenticate to view post details',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return didAuth;
    } catch (_) {
      return false;
    }
  }
}
