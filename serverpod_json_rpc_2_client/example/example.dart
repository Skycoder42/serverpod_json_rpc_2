import 'package:serverpod_json_rpc_2_client/serverpod_json_rpc_2_client.dart';

Future<void> connectStreamChannel(EndpointRef endpoint) async {
  await endpoint.client.openStreamingConnection();

  // ignore: unused_local_variable
  final client = endpoint.createClient();
  // ...
}
