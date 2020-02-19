import 'package:fave_reads/fave_reads.dart';
import '../model/read.dart';


class ReadsController extends ResourceController { 
  ReadsController(this.context);
  ManagedContext context;
  

  @override 
  // implement handle method (Can be used to validate user inputs before operation is triggered )
  // FutureOr<RequestOrResponse> handle(Request request){
  //   switch(request.method){
  //     case 'GET':
  //       return Response.ok('got all reads');
  //     case 'POST':
  //       return Response.ok('created a read');
  //     case 'PUT':
  //       return Response.ok('updated a read');
  //     case 'DELETE':
  //       return Response.ok('deleted a read');
  //     default:
  //       return Response(HttpStatus.methodNotAllowed, null, "method is not allowed");
  //   }
  // } 
  @Operation.get()
  Future<Response> getAllReads() async {
    final readQuery = Query<Read>(context); // pass managed object so it has connection to the db

    return Response.ok(await readQuery.fetch());
  }

  @Operation.get('id')
  Future<Response> getRead(@Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
      ..where((read) => read.id).equalTo(id);
    final read = await readQuery.fetchOne(); 

    if (read == null){
       return Response.notFound(body: "item not found");
    }
    return Response.ok(read);
  }

  @Operation.post()
  Future<Response> createNewRead(@Bind.body() Read body ) async {
    final readQuery = Query<Read>(context)
      ..values = body;  // values is a reference to our read.ManageObject
    final insertedRead = await readQuery.insert(); // inserts our query into the db      
    return Response.ok(insertedRead );
  }

  @Operation.put('id')
  Future<Response> updatedRead(
    @Bind.path('id') int id, //expects to receive a value as id then casts it to int
    @Bind.body() Read body) 
    async { 
    final readQuery = Query<Read>(context)
      ..values = body // updates Payload ->   \\
      ..where((read) => read.id).equalTo(id); // at this index

    final updatedQuery = readQuery.updateOne();
       
    if (updatedQuery == null){
       return Response.notFound(body: "item not found");
    }

    return Response.ok(updatedQuery);
  }

  @Operation.delete('id')
  Future<Response> deleteRead(@Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
      ..where((read) => read.id).equalTo(id);

    final int deleteCount = await readQuery.delete();

    if (deleteCount == 0){
       return Response.notFound(body: "item not found");
    }

    return Response.ok('deleted $deleteCount items');
  }
}