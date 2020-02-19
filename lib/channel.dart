 import 'fave_reads.dart';
 import 'dart:io';
 import 'package:fave_reads/controller/reads_controller.dart';

class FaveReadsChannel extends ApplicationChannel {
  /// Prepare channel to DB
  /// 1. tell app what our data model is
  /// 2. tell app channel what DB we expect to connect to 
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = ReadConfig(options.configurationFilePath); //defaults to config.yaml - options is a part of ApplicationChannel
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();  // searched our library for all subclasses of ManagedObject
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo( //Holds our connects to the PostgresDB
      config.database.username, 
      config.database.password, 
      config.database.host, 
      config.database.port, 
      config.database.databaseName);    
    context = ManagedContext(dataModel, persistentStore);
  }

  @override
  Controller get entryPoint =>  Router()
      ..route("/reads/[:id]").link(() => ReadsController(context)) // using `[]` makes it an optional attribute 
      //
      ..route('/').linkFunction((request) => 
        Response.ok("Hello World")..contentType = ContentType.html)
      //
      ..route('/client').linkFunction((request) async { 
        final client = await File('client.html').readAsString();
        return Response.ok(client)..contentType = ContentType.html;
      });
}

class ReadConfig extends Configuration {
  ReadConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}