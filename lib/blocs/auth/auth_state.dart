part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final auth.User? user;
  const AuthState({
    required this.authStatus,
    this.user,
  });

  factory AuthState.unknown() {
    return const AuthState(authStatus: AuthStatus.unknown);
  }

  @override
  List<Object?> get props => [authStatus, user];

  AuthState copyWith({
    AuthStatus? authStatus,
    auth.User? user,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
    );
  }

  @override
  String toString() => 'AuthState(authStatus: $authStatus, user: $user)';
}
