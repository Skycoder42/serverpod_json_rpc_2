import 'package:serverpod/serverpod.dart';
import 'package:serverpod_json_rpc_2_server/serverpod_json_rpc_2_server.dart';

class MyEndpoint extends Endpoint with EndpointStreamChannel {
  @override
  Future<void> streamOpened(StreamingSession session) async {
    await super.streamOpened(session);

    // ignore: unused_local_variable
    final server = createServer(session);
    // ...
  }
}
