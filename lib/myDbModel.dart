import 'package:sqfentity/sqfentity.dart';



class MyDbModel extends SqfEntityModel {
  MyDbModel() {
    databaseName = "sampleORM1.db";
    databaseTables = [
      TableTodo.getInstance
    ];
    bundledDatabasePath = null;
    // set this property to your DBModel.dart path
    customImports = "import 'MyDbModel.dart';";
  }
}


class TableTodo extends SqfEntityTable {

  TableTodo() {
    // declare properties of EntityTable
    tableName = "todos";
    modelName = null;
    primaryKeyName = "id";
    primaryKeyType = PrimaryKeyType.integer_auto_incremental;
    useSoftDeleting = false;
    defaultJsonUrl = "https://jsonplaceholder.typicode.com/todos";

    fields = [
      SqfEntityField("userId", DbType.integer),
      SqfEntityField("title", DbType.text),
      SqfEntityField("completed", DbType.bool, defaultValue: "false")
    ];

    super.init();
  }
  static SqfEntityTable __instance;
  static SqfEntityTable get getInstance {
    if (__instance == null) __instance = TableTodo();
    return __instance;
  }
}