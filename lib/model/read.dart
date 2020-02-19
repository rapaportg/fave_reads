 import 'package:fave_reads/fave_reads.dart';

 class Read extends ManagedObject<_Read> implements _Read { // Read class is used to create query objects
  @Serialize() // need this to return details in the response to client
  String get details => '$title by $author';
    
 } 

 class _Read {      // table definition for DB. name of table is _Read and has the columns title, author, year 
   @primaryKey
   int id;

   @Column(unique: true )
   String title;

   @Column()
   String author;

   @Column ()
   int year;

 }