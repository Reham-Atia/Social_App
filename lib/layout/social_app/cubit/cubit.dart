import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/modules/social_app/chats/chats_screen.dart';
import 'package:social_app/modules/social_app/feeds/feeds_screen.dart';
import 'package:social_app/modules/social_app/new_post/new_post_screen.dart';
import 'package:social_app/modules/social_app/profile/profile_screen.dart';
import 'package:social_app/modules/social_app/users/users_screen.dart';
import 'package:social_app/shared/components/constans.dart';
import 'package:social_app/models/social_app/message_model.dart';
import 'package:social_app/models/social_app/post_model.dart';
import 'package:social_app/models/social_app/social_user_model.dart';

class SocialCubit extends Cubit<SocialStates>
{
  SocialCubit() :super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel userModel;

  int currentIndex = 0;

  List<Widget> screens =
  [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    ProfileScreen(),
  ];

  List<String> titles =
  [
    'Home',
    'Chats',
    'Add Post',
    'Users',
    'Profile',
  ];

  void changeNavBar(int index)
  {
    if(index == 1 )
    {
      getAllUsers();
    }
    if(index == 2)
    {
      emit(SocialNewPostState());
    }else
      {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  void getUserData()
  {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value)
    {
      userModel = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  var picker = ImagePicker();
  File profileImage;

  Future<void> getProfileImage()
  async
  {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery
    );
    if(pickedFile != null)
    {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    }else
    {
      print('No Image Selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File coverImage;

  Future<void> getCoverImage()
  async
  {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery
    );
    if(pickedFile != null)
    {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    }else
    {
      print('No Image Selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }


  void uploadProfileImage({
    @required String name,
    @required String phone,
    @required String bio,
})
  {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value)
    {
      value.ref.getDownloadURL().then((value)
      {

        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
        //emit(SocialUploadProfileImageSuccessState());
      }).catchError((error){
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error)
    {
      emit(SocialUploadProfileImageErrorState());
    });
  }


  void uploadCoverImage({
    @required String name,
    @required String phone,
    @required String bio,
  })
  {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value)
    {
      value.ref.getDownloadURL().then((value)
      {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
        //emit(SocialUploadCoverImageSuccessState());
      }).catchError((error)
      {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error)
    {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
    String image,
    String cover,
  })
  {
    SocialUserModel model = SocialUserModel(
      name : name,
      phone : phone,
      bio: bio,
      email: userModel.email,
      image: image??userModel.image,
      cover: cover??userModel.cover,
      uId: userModel.uId,
      isEmailVerified : false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(model.toMap())
        .then((value)
    {
      getUserData();

    }).catchError((error)
    {
      emit(SocialUserUpdateErrorState());
    });
  }

  File postImage;

  Future<void> getPostImage()
  async
  {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery
    );
    if(pickedFile != null)
    {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    }else {
      print('No Image Selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage()
  {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    @required String dateTime,
    @required String text,
  })
  {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value)
    {
      value.ref.getDownloadURL().then((value)
      {
        createPost(
            dateTime: dateTime,
            text: text,
            postImage: value,
        );
      }).catchError((error){
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error)
    {
      emit(SocialCreatePostErrorState());
    });
  }


  // Create Post

  void createPost({
    @required String dateTime,
    @required String text,
    String postImage,
  })
  {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name : userModel.name,
      image: userModel.image,
      uId: userModel.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage??'',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value)
    {
      emit(SocialCreatePostSuccessState());
    }).catchError((error)
    {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        element.reference
        .collection('likes')
        .get()
        .then((value)
        {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        })
        .catchError((error) {});
      });
      emit(SocialGetPostsSuccessState());
    })
        .catchError((error)
    {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
        .set({
      'like' : true,
    })
        .then((value)
    {
      emit(SocialLikePostSuccessState());
    })
        .catchError((error)
    {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  List<SocialUserModel> users = [];

  void getAllUsers()
  {
    if(users.length == 0)
    {
      FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        if(element.data()['uId'] != userModel.uId)
        {
          users.add(SocialUserModel.fromJson(element.data()));
        }
      });
      emit(SocialGetAllUsersSuccessState());
    }).catchError((error)
    {
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
    }
  }

  void sendMessage({
  @required String receiverId,
  @required String dateTime,
  @required String text,
}){
    MessageModel model = MessageModel(
      text: text,
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: userModel.uId,
    );
    //set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
          emit(SocialSendMessageSuccessState());
    })
        .catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    //set receive chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error) {
      emit(SocialSendMessageErrorState());
    });


  }

  List<MessageModel> messages = [];

  void getMessages({
    @required String receiverId,
})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      messages = [];
          event.docs.forEach((element)
          {
            messages.add(MessageModel.fromJson(element.data()));
          });

          emit(SocialGetMessagesSuccessState());
    });
  }


  //Add Photos

  File addPhotos;

  Future<void> getPhotos()
  async
  {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery
    );
    if(pickedFile != null)
    {
      addPhotos = File(pickedFile.path);
      emit(SocialPhotosPickedSuccessState());
    }else {
      print('No Image Selected.');
      emit(SocialPhotosPickedErrorState());
    }
  }

  void removePhotos()
  {
    addPhotos = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPhotos()
  {
    emit(SocialAddPhotosLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(addPhotos.path).pathSegments.last}')
        .putFile(addPhotos)
        .then((value)
    {
      value.ref.getDownloadURL().then((value)
      {
        emit(SocialAddPhotosSuccessState());
      }).catchError((error){
        emit(SocialAddPhotosErrorState());
      });
    }).catchError((error)
    {
      emit(SocialAddPhotosErrorState());
    });
  }

}