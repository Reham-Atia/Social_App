import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_app/cubit/cubit.dart';
import 'package:social_app/layout/social_app/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icons_broken.dart';


class EditProfileScreen extends StatelessWidget
{

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();

  EditProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;

        nameController.text = userModel.name;
        phoneController.text = userModel.phone;
        bioController.text = userModel.bio;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              defaultTextBottom(
                function: () {
                  SocialCubit.get(context).updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text,
                  );
                },
                text: 'UPDATE',
              ),
              SizedBox(
                width: 20.0,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children:
                [
                  if (state is SocialUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 195.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 140.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                    image: DecorationImage(
                                      image: coverImage == null
                                          ? NetworkImage(
                                              '${userModel.cover}',
                                            )
                                          : FileImage(coverImage),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: 5.0,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                  icon: CircleAvatar(
                                    backgroundColor: Colors.black12,
                                    radius: 22.0,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 17.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: profileImage == null
                                    ? NetworkImage(
                                        '${userModel.image}',
                                      )
                                    : FileImage(profileImage),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                              icon: CircleAvatar(
                                backgroundColor: Colors.black12,
                                radius: 22.0,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 17.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).profileImage != null)
                          Expanded(
                            child: OutlinedButton(
                                onPressed: ()
                                {
                                  SocialCubit.get(context).uploadProfileImage(
                                      name: nameController.text,
                                      bio: bioController.text,
                                      phone: phoneController.text
                                  );
                                },
                                child: Text(
                                    'upload image'
                                ),
                            ),
                          ),
                        SizedBox(
                          width: 10.0,
                        ),
                        if (SocialCubit.get(context).coverImage != null)
                          Expanded(
                            child: OutlinedButton(
                                onPressed: ()
                                {
                                  SocialCubit.get(context).uploadCoverImage(
                                      name: nameController.text,
                                      bio: bioController.text,
                                      phone: phoneController.text
                                  );
                                },
                                child: Text(
                                    'upload cover'
                                )
                            ),
                          ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    SizedBox(
                      height: 10.0,
                    ),
                    // Row(
                    //   children:
                    //   [
                    //     if (SocialCubit.get(context).profileImage != null)
                    //       Expanded(
                    //         child: OutlinedButton(
                    //           onPressed: ()
                    //           {
                    //             SocialCubit.get(context).uploadProfileImage(
                    //               name: nameController.text,
                    //               phone: phoneController.text,
                    //               bio: bioController.text,
                    //             );
                    //           },
                    //           child: Text(
                    //             'Upload Profile image',
                    //           ),
                    //         ),
                    //       ),
                    //     SizedBox(
                    //       width: 5.0,
                    //     ),
                    //     if (SocialCubit.get(context).coverImage != null)
                    //       Expanded(
                    //         child:  OutlinedButton(
                    //           onPressed: () {
                    //             SocialCubit.get(context).uploadCoverImage(
                    //               name: nameController.text,
                    //               phone: phoneController.text,
                    //               bio: bioController.text,
                    //             );
                    //           },
                    //           child: Text(
                    //             'Upload Cover image',
                    //           ),
                    //         ),
                    //       ),
                    //     SizedBox(
                    //       height: 5.0,
                    //     )
                    //   ],
                    // ),
                  defaultTextFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    label: 'Name',
                    prefix: IconBroken.User,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'name must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultTextFormField(
                    controller: phoneController,
                    type: TextInputType.phone,
                    label: 'Phone',
                    prefix: IconBroken.Call,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'Phone must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultTextFormField(
                    controller: bioController,
                    type: TextInputType.text,
                    label: 'Bio',
                    prefix: IconBroken.Info_Circle,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'bio must not be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
