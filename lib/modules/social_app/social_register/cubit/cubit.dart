import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/social_app/social_register/cubit/states.dart';
import 'package:social_app/models/social_app/social_user_model.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates>
{
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);


  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  })
  {
    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value)
    {
      userCreate(
          name: name,
          email: email,
          phone: phone,
          uId: value.user.uid,
      );
    }).catchError((error)
    {
      emit(SocialRegisterErrorState(error));
    });
  }


  void userCreate({
    @required String name,
    @required String email,
    @required String phone,
    @required String uId,
}){
    SocialUserModel model = SocialUserModel(
      name : name,
      email : email,
      phone : phone,
      uId : uId,
      image: 'https://as1.ftcdn.net/v2/jpg/02/45/10/16/1000_F_245101600_TAOjE6DN7Z6rf7EZbKgB0TwzMLlAdwUx.jpg',
      cover: 'https://as1.ftcdn.net/v2/jpg/02/45/10/16/1000_F_245101600_TAOjE6DN7Z6rf7EZbKgB0TwzMLlAdwUx.jpg',
      bio: 'write your bio ...',
      isEmailVerified : false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap()
    ).then((value)
    {
      emit(SocialUserCreateSuccessState());
    }).catchError((error)
    {
      emit(SocialUserCreateErrorState(error));
      print(error.toString());
    });
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility ()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined ;

    emit(SocialRegisterChangePasswordVisibilityState());
  }

}