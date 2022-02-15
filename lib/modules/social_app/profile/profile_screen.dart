import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/modules/social_app/edit_profile/edit_profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icons_broken.dart';

class ProfileScreen extends StatelessWidget
{
  const ProfileScreen({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state)
        {
          var userModel = SocialCubit.get(context).userModel;
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: 195.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Container(
                          width: double.infinity,
                          height: 140.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  '${userModel.cover}',
                                ),
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 64.0,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(
                            '${userModel.image}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${userModel.name}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  '${userModel.bio}',
                  style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 14.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '120',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'Posts',
                                style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                          onTap: (){},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '245',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'Photos',
                                style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                          onTap: (){},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '15K',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'Followers',
                                style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                          onTap: (){},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children:
                            [
                              Text(
                                '101',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                'Following',
                                style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                          onTap: (){},
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          SocialCubit.get(context).getPhotos();
                        },
                        child: Text(
                          '+ Add Photos',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    OutlinedButton(
                      onPressed: (){
                        navigateTo(context, EditProfileScreen());
                      },
                      child: Icon(
                        IconBroken.Edit,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: ()
                        {
                          FirebaseMessaging.instance.subscribeToTopic('announcements');
                          print('Subscribe');
                        },
                        child: Text(
                          'Subscribe',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: ()
                        {
                          FirebaseMessaging.instance.unsubscribeFromTopic('announcements');
                          print('Un subscribe');
                        },
                        child: Text(
                          'UnSubscribe',
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 160.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image: FileImage(SocialCubit.get(context).addPhotos),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 5.0,
                      ),
                      child: IconButton(
                        onPressed: () {
                          SocialCubit.get(context).removePhotos();
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.black12,
                          radius: 22.0,
                          child: Icon(
                            Icons.close,
                            size: 17.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children:
                //   [
                //     Container(
                //       height: 110.0,
                //       width: 160.0,
                //       child: Image(
                //           image: NetworkImage(
                //               'https://image.freepik.com/free-vector/vector-banner-software-development_107791-3284.jpg',
                //           )
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
