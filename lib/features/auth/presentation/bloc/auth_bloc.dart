import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/common/cubits/cubit/auth_cubit.dart';
import 'package:ordering_app/core/common/entities/login_info_entity.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/auth/domain/use_cases/delete_account.dart';
import 'package:ordering_app/features/auth/domain/use_cases/fetch_login_info.dart';
import 'package:ordering_app/features/auth/domain/use_cases/forgot_password.dart';
import 'package:ordering_app/features/auth/domain/use_cases/login.dart';
import 'package:ordering_app/features/auth/domain/use_cases/logout.dart';
import 'package:ordering_app/features/auth/domain/use_cases/register.dart';
import 'package:ordering_app/features/auth/domain/use_cases/reset_password.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Logout _logout;
  final Register _register;
  final FetchLoginInfo _fetchLoginInfo;
  final DeleteAccount _deleteAccount;
  final ForgotPassword _forgotPassword;
  final ResetPassword _resetPassword;

  final AuthCubit _authCubit;

  AuthBloc({
    required Login login,
    required Logout logout,
    required Register register,
    required FetchLoginInfo fetchLoginInfo,
    required AuthCubit authCubit,
    required DeleteAccount deleteAccount,
    required ForgotPassword forgotPassword,
    required ResetPassword resetPassword,
  })  : _login = login,
        _logout = logout,
        _register = register,
        _fetchLoginInfo = fetchLoginInfo,
        _authCubit = authCubit,
        _deleteAccount = deleteAccount,
        _forgotPassword = forgotPassword,
        _resetPassword = resetPassword,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(AuthLoading());
    });
    on<LoginEvent>(_onLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<FetchLoginInfoEvent>(_onFetchLoginInfoEvent);
    on<DeleteAccountEvent>(_onDeleteAccountEvent);
    on<ForgotPasswordEvent>(_onForgotPasswordEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
  }

  void _onLoginEvent(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _login(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(error: l.message)),
      (r) => _emitAuthSuccess(emit, r),
    );
  }

  void _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _logout(NoParams());
    res.fold(
      (l) => emit(AuthFailure(error: l.message)),
      (r) {
        _authCubit.authenticate(loginInfoEntity: null);
        emit(AuthLogoutSuccess());
      },
    );
  }

  void _onRegisterEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _register(
      RegisterParams(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        telephone: event.telephone,
        password: event.password,
        confirm: event.confirm,
        agree: event.agree,
        newsletter: event.newsletter,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(error: l.message)),
      (r) => _emitAuthSuccess(emit, r),
    );
  }

  void _onFetchLoginInfoEvent(
    FetchLoginInfoEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _fetchLoginInfo(NoParams());
    res.fold(
      (l) => emit(AuthInitial()),
      (r) {
        _authCubit.authenticate(loginInfoEntity: r);
        emit(AuthInitialSuccess(
          loginInfoEntity: r,
        ));
      },
    );
  }

  void _onDeleteAccountEvent(
    DeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _deleteAccount(
      DeleteAccountParams(
        password: event.password,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(error: l.message)),
      (r) => emit(AccountDeleteSuccess(message: r)),
    );
  }

  void _onForgotPasswordEvent(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _forgotPassword(
      ForgotPasswordParams(
        email: event.email,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(error: l.message)),
      (r) => emit(ForgotPasswordSuccess(r)),
    );
  }

  void _onResetPasswordEvent(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _resetPassword(
      ResetPasswordParams(
        password: event.password,
        confirm: event.confirm,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(error: l.message)),
      (r) => emit(
        ResetPasswordSuccess(message: r),
      ),
    );
  }

  void _emitAuthSuccess(
    Emitter<AuthState> emit,
    LoginInfoEntity loginInfoEntity,
  ) {
    _authCubit.authenticate(loginInfoEntity: loginInfoEntity);
    emit(AuthSuccess(loginInfoEntity));
  }
}
