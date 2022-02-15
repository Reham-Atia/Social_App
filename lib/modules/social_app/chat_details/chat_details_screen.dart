import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icons_broken.dart';
import 'package:social_app/models/social_app/message_model.dart';
import 'package:social_app/models/social_app/social_user_model.dart';

class ChatDetailsScreen extends StatelessWidget
{

  SocialUserModel userModel;

  ChatDetailsScreen({Key key, this.userModel }) : super(key: key);

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Builder(
      builder: (BuildContext context)
      {
        SocialCubit.get(context).getMessages(
            receiverId: userModel.uId
        );

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state)
          {
            return  Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(
                      IconBroken.Arrow___Left_2
                  ),
                      onPressed: ()
                      {
                        Navigator.pop(context);
                      },
                ),
                titleSpacing: 0.0,
                title: Row(
                  children:
                  [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        userModel.image,
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      userModel.name,
                      style: const TextStyle(
                        height: 1.2,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children:
                  [
                    Expanded(
                      child: ConditionalBuilder(
                        condition: SocialCubit.get(context).messages.length > 0,
                        builder: (context) => Column(
                          children:
                          [
                            Expanded(
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index)
                                {
                                  var message = SocialCubit.get(context).messages[index];
                                  if(SocialCubit.get(context).userModel.uId == message.senderId)
                                  {
                                    return buildMyMessage(message);
                                  }
                                  return buildMessage(message);
                                },
                                separatorBuilder: (context, index) => const SizedBox(
                                  height: 15.0,
                                ),
                                itemCount: SocialCubit.get(context).messages.length,
                              ),
                            ),
                          ],
                        ),
                        fallback: (context) => const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: Colors.grey[300],
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: TextFormField(
                                controller: messageController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message here...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50.0,
                            child: MaterialButton(
                              onPressed: ()
                              {
                                SocialCubit.get(context).sendMessage(
                                  receiverId: userModel.uId,
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text,
                                );
                              },
                              minWidth: 1.0,
                              child: const Icon(
                                IconBroken.Send,
                                color: Colors.teal,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },

    );
  }

  Widget buildMessage(MessageModel model) =>  Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10.0),
          topStart: Radius.circular(10.0),
          topEnd: Radius.circular(10.0),
        ),
        color: defaultColor.withOpacity(.2),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Text(
        model.text,
      ),
    ),
  );


  Widget buildMyMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(10.0),
          topStart: Radius.circular(10.0),
          topEnd: Radius.circular(10.0),
        ),
        color: Colors.grey[300],
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Text(
        model.text,
      ),
    ),
  );


}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:conditional_builder/conditional_builder.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:new_project/layout/social_app/cubit/cubit.dart';
// import 'package:new_project/layout/social_app/cubit/states.dart';
// import 'package:new_project/models/social_app/message_model.dart';
// import 'package:new_project/models/social_app/social_user_model.dart';
// import 'package:new_project/shared/styles/icons_broken.dart';
//
// class DevicesChatScreen extends StatelessWidget
// {
//   SocialUserModel socialUserModel;
//
//   DevicesChatScreen({Key key, @required this.socialUserModel})
//       : super(key: key);
//
//   final _messageController = TextEditingController();
//
//   DateFormat dateFormat = DateFormat("HH:mm:ss");
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Builder(
//       builder: (BuildContext context) {
//         SocialCubit.get(context).getMessages(receiverId: socialUserModel.uId);
//         return BlocConsumer<SocialCubit, SocialStates>(
//             listener: (context, states) {},
//             builder: (context, states) {
//               var cubitMessage = SocialCubit.get(context);
//               return Scaffold(
//                 appBar: AppBar(
//                     title: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           radius: 15.0,
//                           backgroundImage: NetworkImage(
//                             '${socialUserModel.image}',
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10.0,
//                         ),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.only(
//                                     top: 5.0, start: 5.0),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       '${socialUserModel.name}',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodyText1
//                                           .copyWith(
//                                         fontSize: 18.0,
//                                         color: Colors.black,
//                                         height: 1.0,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     leading: IconButton(
//                       icon: const Icon(IconBroken.Arrow___Left_2),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     )),
//                 body: Column(
//                   children: [
//                     Expanded(
//                       child: ConditionalBuilder(
//                         condition: cubitMessage.messages.length > 0,
//                         builder: (context) => Column(
//                           children: [
//                             Expanded(
//                               child: ListView.separated(
//                                 itemBuilder: (context, index)
//                                 {
//                                   var message = cubitMessage.messages[index];
//                                   print(cubitMessage.messages[index].toMap());
//                                   if(socialUserModel.uId == message.receiverId) {
//
//                                     return builderMessageReceiver(message);
//                                   }
//                                   return builderMessageSend(message);
//                                 },
//                                 separatorBuilder: (context, index) => SizedBox(
//                                   height: 5.0,
//                                 ),
//                                 itemCount: cubitMessage.messages.length,
//                               ),
//                             ),
//                           ],
//                         ),
//                         fallback: (context) => const Center(child: CircularProgressIndicator()),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: TextField(
//                         controller: _messageController,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(50.0),
//                           ),
//                           hintText: 'Type your message here',
//                           hintStyle: const TextStyle(
//                             color: Colors.grey,
//                           ),
//                           prefixIcon: InkWell(
//                             child: const Icon(Icons.camera_alt),
//                             onTap: () {},
//                           ),
//                           suffixIcon: IconButton(
//                             onPressed: () {
//                               cubitMessage.sendMessage(
//                                   receiverId: socialUserModel.uId,
//                                   text: _messageController.text,
//                                   dataTime: Timestamp.now().toString()
//                               );
//                               _messageController.clear();
//                             },
//                             icon: const Icon(
//                               Icons.send,
//                             ),
//                           ),
//                         ),
//                         style: const TextStyle(color: Colors.black, height: 1),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//               // const Center(child: CircularProgressIndicator()),
//             }
//         );
//       },
//     );
//   }
//
//   Widget builderMessageSend(MessageModel model) => Align(
//     alignment: AlignmentDirectional.topStart,
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//       child: Container(
//         child: Text(
//           model.text,
//           style: TextStyle(fontSize: 18.0),
//         ),
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: BorderRadiusDirectional.only(
//             bottomEnd: Radius.circular(10.0),
//             topEnd: Radius.circular(10.0),
//             topStart: Radius.circular(10.0),
//           ),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//       ),
//     ),
//   );
//
//   Widget builderMessageReceiver(MessageModel model) => Align(
//     alignment: AlignmentDirectional.bottomEnd,
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//       child: Container(
//         child: Text(
//           model.text,
//           style: TextStyle(fontSize: 18.0),
//         ),
//         decoration: BoxDecoration(
//           color: Colors.blue[300],
//           borderRadius: BorderRadiusDirectional.only(
//             topEnd: Radius.circular(10.0),
//             topStart: Radius.circular(10.0),
//             bottomStart: Radius.circular(10.0),
//           ),
//         ),
//         padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//       ),
//     ),
//   );
// }