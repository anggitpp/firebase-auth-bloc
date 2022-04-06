import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';
import '../../repositories/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignUpState> {
  final AuthRepository authRepository;

  SignupCubit({required this.authRepository}) : super(SignUpState.initial());

  Future<void> signUp(
      {required String name,
      required String email,
      required String password}) async {
    emit(state.copyWith(signUpStatus: SignUpStatus.submitting));

    try {
      await authRepository.signUp(name: name, email: email, password: password);

      emit(state.copyWith(signUpStatus: SignUpStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(signUpStatus: SignUpStatus.error, error: e));
    }
  }
}
