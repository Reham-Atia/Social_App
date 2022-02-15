import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/social_app/social_login/cubit/state.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates>
{
  SocialLoginCubit() : super(SocialLoginInitialStates());

  static SocialLoginCubit get(context) => BlocProvider.of(context);


  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void userLogin({
    @required String email,
    @required String password,
})
  {
    emit(SocialLoginLoadingStates());

   FirebaseAuth.instance.signInWithEmailAndPassword(
       email: email,
       password: password,
   ).then((value)
   {
     print(value.user.email);
     print(value.user.uid);
     emit(SocialLoginSuccessStates(value.user.uid));
   }).catchError((error)
   {
     emit(SocialLoginErrorStates(error.toString()));
   });
  }

  void changePasswordVisibility ()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined ;

    emit(SocialChangePasswordVisibilityState());
  }
}

