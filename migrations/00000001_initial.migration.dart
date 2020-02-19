import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration1 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("_Read", [
         SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
         SchemaColumn("title", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: true),
         SchemaColumn("author", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
         SchemaColumn("year", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)
         ]));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {
    final List<Map> reads = 
    [
      {
        'title':"Heads first design pattern",
        'author':"Eric Freeman",
        'year': 2014
      },
      {
        'title':"Think and Grow Rich",
        'author':"A Smartguy",
        'year': 2010
      },
      {
        'title':"The Foundation",
        'author':"Issac Asimov",
        'year': 2004
      }
    ];

    for (final read in reads){  // execute db 'sql' command to enter seed data into db 
       await database.store.execute(  // execute sql query to populate 
          'INSERT INTO _Read (title, author, year) VALUES (@title, @author, @year)', //these columns
          substitutionValues: { // with these values
           'title': read['title'],
           'author': read['author'],
           'year': read['year']
         }
       );
    }
  }
}
    