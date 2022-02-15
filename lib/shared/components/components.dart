import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/icons_broken.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.teal,
  bool isUpperCase = true,
  double radius = 5.0,
  @required String text,
  @required Function function,

}) => Container(
  width: width,
  height: 40.0,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
  child: MaterialButton(
    onPressed: (){
      function();
    },
    child: Text(
      isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.white,
      ),
    ),
    height: 50.0,
  ),
);

Widget defaultTextBottom({
  @required function,
  @required String text,
  Color color,
}) => TextButton(
  onPressed: function,
  child: Text(
    text.toUpperCase(),
    style: TextStyle(
      color: color,
    ),
  ),


);

Widget defaultTextFormField({
  onTap,
  @required TextEditingController controller,
  @required TextInputType type,
  @required String label,
  @required IconData prefix,
  @required validate,
  suffixPressed,
  onSubmit,
  // Function? onChange,
  onChange,
  IconData suffix,
  bool isPassword = false,
}) =>  TextFormField(
  onChanged: onChange,
  validator: validate,
  onTap: onTap,
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onSubmit,
  // onChanged: (String value)
  // {
  //   onChange!();
  // },
  decoration: InputDecoration(
    labelStyle: TextStyle(
      color: Colors.grey,
    ),
    labelText: label,
    prefixIcon: Icon(
      prefix,
      color: Colors.teal,
    ),
    suffixIcon: suffix != null ? IconButton(
      onPressed: suffixPressed,
      icon: Icon(
        suffix,
        color: Colors.teal,
      ),
    ) : null ,
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.teal,
      ),
    ),
  ),
);

Widget defaultAppBar({
  @required BuildContext context,
  String title,
  List<Widget> actions,
}) => AppBar(
  titleSpacing: 0.0,
  leading: IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon: Icon(
        IconBroken.Arrow___Left_2,
      ),
  ),
  title: Text(
    title,
  ),
  actions: actions,
);

Widget BuildTasksItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.teal,
          radius: 40.0,
          child: Text(
            '${model['time']}',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 0.5,
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        IconButton(
            onPressed: (){
              // AppCubit.get(context).updateData(
              //   status: 'done',
              //   id: model['id'],
              // );
            },
            icon: Icon(
              Icons.done,
              color: Colors.teal,
            )
        ),
        IconButton(
            onPressed: (){
              // AppCubit.get(context).updateData(
              //   status: 'archive',
              //   id: model['id'],
              // );
            },
            icon: Icon(
              Icons.archive,
              color: Colors.teal,
            )
        ),
      ],
    ),
  ),
  onDismissed: (direction)
  {
    // AppCubit.get(context).deleteData(id: model['id']);
  },
);

Widget tasksBuilder({
  @required List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => BuildTasksItem(tasks[index], context),
    separatorBuilder: (context, index) => myDivider() ,
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          color: Colors.grey[400],
          size: 80.0,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16.0,
          ),
        ),
      ],
    ),
  ),
);

Widget myDivider() => Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 20.0,
  ),
  child: Container(
    color: Colors.grey[400],
    height: 0.3,
    width: double.infinity,
  ),
);

Widget buildArticleItem(article, context) => InkWell(
  onTap: (){
    //navigateTo(context, WebViewScreen(article['url']));
  },
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        Container(

          height: 120.0,

          width: 120.0,

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10.0),

            image: DecorationImage(

              image: NetworkImage('${article['urlToImage']}'),

              fit: BoxFit.cover,

            ),

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Container(

            height: 120.0,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.start,

              children: [

                Expanded(

                  child: Text(

                    '${article['title']}',

                    style: Theme.of(context).textTheme.headline6,

                    maxLines: 3,

                    overflow: TextOverflow.ellipsis,

                  ),

                ),

                Text(

                  '${article['publishedAt']}',

                  style: TextStyle(

                    fontSize: 16.0,

                    color: Colors.grey,

                  ),

                ),

              ],

            ),

          ),

        ),

      ],

    ),

  ),
);

Widget articleBuilder(list, context, {isSearch = false}) => ConditionalBuilder(
  condition: list.length > 0,
  builder: (context) => ListView.separated(
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) => buildArticleItem(list[index], context),
    separatorBuilder: (context, index) => myDivider(),
    itemCount: 10,
  ),
  fallback: (context) => isSearch ? Container() : Center(child: CircularProgressIndicator()),
);

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context)=> widget,
  ),
);

void navigateAndFinish(
    context,
    widget,
    ) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (route) {
        return false;
      },
    );

void showToast({
  @required String text,
  @required ToastStates state,
}) => Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0);

enum ToastStates {SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates state)
{
  Color color;

  switch(state){
    case ToastStates.SUCCESS:
      color =Colors.green;
      break;
    case ToastStates.ERROR:
      color =Colors.red;
      break;
    case ToastStates.WARNING:
      color =Colors.amber;
      break;
  }
  return color;
}
