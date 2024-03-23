import 'package:serverpod_json_rpc_2_shared/src/rpc_stream_channel_transformer.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:stream_channel/stream_channel.dart';

void sampleCreateChannel(StreamChannel<SerializableEntity> channel) =>
    channel.transform(RpcStreamChannelTransformer());
