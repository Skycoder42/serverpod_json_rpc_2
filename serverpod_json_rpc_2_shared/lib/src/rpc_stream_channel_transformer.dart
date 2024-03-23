import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:stream_channel/stream_channel.dart';

import 'json_rpc_2_message.dart';

class _RpcEncoder extends Converter<dynamic, SerializableEntity> {
  const _RpcEncoder();

  @override
  SerializableEntity convert(dynamic input) => JsonRpc2Message(input);
}

class _RpcDecoder extends Converter<SerializableEntity, dynamic> {
  const _RpcDecoder();

  @override
  dynamic convert(SerializableEntity input) =>
      input is JsonRpc2Message ? input.raw : input;
}

class _RpcCodec extends Codec<dynamic, SerializableEntity> {
  const _RpcCodec();

  @override
  _RpcDecoder get decoder => const _RpcDecoder();

  @override
  _RpcEncoder get encoder => const _RpcEncoder();
}

/// A transformer that wraps/unwraps generic JSON events as [JsonRpc2Message]
///
/// This transformer can be applied to a [StreamChannel]<[SerializableEntity]>.
/// The resulting stream channel accepts (and emits) any kind of data (that can
/// be JSON de/serialized) and wraps it in a [JsonRpc2Message], before passing
/// it to the transformed channel.
class RpcStreamChannelTransformer
    extends StreamChannelTransformer<dynamic, SerializableEntity> {
  /// Default constructor
  RpcStreamChannelTransformer() : super.fromCodec(const _RpcCodec());
}
