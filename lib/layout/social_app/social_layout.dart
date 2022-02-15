import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/modules/social_app/notifications/notifications_screen.dart';
import 'package:social_app/modules/social_app/search/search_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icons_broken.dart';


class SocialLayout extends StatelessWidget
{
  const SocialLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<SocialCubit, SocialStates>(
     listener: (context, state) {},
     builder: (context, state)
     {
       var cubit = SocialCubit.get(context);
       return Scaffold(
         appBar: AppBar(
           titleSpacing: 20.0,
           title: Text(
               cubit.titles[cubit.currentIndex]
           ),
           actions: [
             IconButton(
                 onPressed: ()
                 {
                   navigateTo(context, NotificationsScreen());
                 },
                 icon: Icon(IconBroken.Notification)),
             IconButton(
                 onPressed: (){
                   navigateTo(context, SearchScreen());
                 },
                 icon: Icon(IconBroken.Search)),
           ],
         ),
         body: cubit.screens[cubit.currentIndex],
         bottomNavigationBar: BottomNavigationBar(
           selectedItemColor: Colors.teal,
           currentIndex: cubit.currentIndex,
           onTap: (index){
             cubit.changeNavBar(index);
           },
           items:
           [
             BottomNavigationBarItem(
                 icon: Icon(
                     IconBroken.Home,
                 ),
                 label: 'Home',
             ),
             BottomNavigationBarItem(
                 icon: Icon(
                     IconBroken.Chat,
                 ),
                 label: 'Chats',
             ),
             BottomNavigationBarItem(
               icon: Icon(
                 IconBroken.Paper_Upload,
               ),
               label: 'Post',
             ),
             BottomNavigationBarItem(
                 icon: Icon(
                     IconBroken.Location,
                 ),
                 label: 'User',
             ),
             BottomNavigationBarItem(
                 icon: Icon(
                     IconBroken.Profile,
                 ),
                 label: 'Profile',
             ),
           ],
         ),
       );
       },
    );
  }
}

