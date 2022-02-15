import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  bool isDark = false;



  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  // List<Widget> screens = [
  //   const newTaskScreen(),
  //   const doneTaskScreen(),
  //   const archiveTaskScreen(),
  // ];

  void changeIndex (int index){
    currentIndex = index;
    emit(AppChangeBottomNavBar());
  }

  void createDatabase() async
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version)
      {
        print('database created');
        database.execute(
            'CREATE TABLE Task (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
        ).then((value) {
          print('table created');
        }).catchError((error){
          print('الايروووور  ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value){
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    @required String title,
    @required String date,
    @required String time,
  }) async {
    await database.transaction((txn){
      return txn.rawInsert(
          'INSERT INTO Task (title, date, time, status) VALUES("$title", "$date", "$time", "new")');
    }).then((value){
      print('$value insert successfully');
      emit(AppInsertDatabaseState());

      getDataFromDatabase(database);
    }).catchError((error){
      print('error is ${error.toString()}');
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM Task').then((value){

      value.forEach((element) {
        if(element['status']== 'new')
          newTasks.add(element);
        else if (element['status']== 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    @required String status,
    @required int id,
  }) async
  {
    database.rawUpdate(
        'UPDATE task SET status = ? WHERE id = ?',
        ['$status', id]).then((value){

      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    @required int id,
  }){
    database.rawDelete(
        'DELETE FROM task WHERE id = ?', [id]
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  })
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

  void changeAppMode({bool fromShared})
  {
    if(fromShared != null)
    {
      isDark = fromShared;
      emit(NewsChangeAppModeState());
    }
    else
    {
      isDark = !isDark;
      CacheHelper.putBoolData(key: 'isDark', value: isDark).then((value){
        emit(NewsChangeAppModeState());
      });
    }
  }


}