import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final canCheck = await _auth.canCheckBiometrics;
    if (canCheck) {
      try {
        final didAuth = await _auth.authenticate(
          localizedReason: 'Autenticati per vedere i dettagli del post',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        return didAuth;
      } catch (_) {
        // fallback a PIN
      }
    }
    // Fallback PIN
    // Per il test puoi aprire un dialog e controllare una stringa
    return false;
  }
}
