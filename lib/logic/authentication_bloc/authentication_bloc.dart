import 'dart:async';

import 'package:authentication/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOuttoState();
    }
  }

//Authentication Started
  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = _userRepository.isSignedIn();
    if (isSignedIn) {
      final firebaseUser = _userRepository.getUser();
      yield AuthenticationSuccess(firebaseUser);
    } else {
      yield AuthenticationFailure();
    }
  }

//Authentication LoggedIn
  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    yield AuthenticationSuccess(_userRepository.getUser());
  }
//Authentication LoggedOut

  Stream<AuthenticationState> _mapAuthenticationLoggedOuttoState() async* {
    yield AuthenticationFailure();
    _userRepository.signout();
  }
}
