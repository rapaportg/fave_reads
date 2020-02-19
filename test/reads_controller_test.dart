import 'harness/app.dart';
import 'package:fave_reads/model/read.dart';

void main() {
  final harness = Harness()..install();

  setUp(() async { // populates the test database with some data
    final readQuery = Query<Read>(harness.application.channel.context)
      ..values.title = "The Great Expectations"
      ..values.author = "Someone I. Shouldknow"
      ..values.year = 1951;
      await readQuery.insert();
  });

  test('GET /reads returns 200 OK', () async {
    final response = await harness.agent.get('/reads');
    expectResponse(response, 200, body: everyElement({
      "id" : greaterThan(0),
      "title" : isString,
      "author" : isString,
      "year" : isInteger,
      "details" : isString
    }));
  });

  test('GET /reads returns 200 OK', () async {
    final response = await harness.agent.get('/reads');
    expectResponse(response, 200, body: everyElement(partial({
      "id" : greaterThan(0),
      "title" : isString,
      "author" : isString,
      "year" : isInteger,
    })));
  });

  test('GET /reads/:id returns a single read', () async {
    final response = await harness.agent.get('/reads/1');
    expectResponse(response, 200, body: {
      'id' : 1,
      'title' : 'The Great Expectations',
      'author' : 'Someone I. Shouldknow',
      'year' : 1951,
      'details' : 'The Great Expectations by Someone I. Shouldknow',
    });
  });

}