import 'package:json_rpc_2/json_rpc_2.dart' as rpc;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_json_rpc_2_shared/serverpod_json_rpc_2_shared.dart';
import 'package:stream_channel/stream_channel.dart';

import 'endpoint_stream_channel.dart';

/// An extension on [Endpoint]s that uses the [EndpointStreamChannel] mixin to
/// create JSON RPC 2.0 instances.
///
/// See [EndpointStreamChannel] for more details on how these channels behave.
extension EndpointRpc on EndpointStreamChannel {
  /// Creates a [rpc.Client] for the given [session].
  ///
  /// Internally, this uses [channelFor] to obtain a stream channel for the
  /// session. This methods returns `null` for the same reasons as [channelFor].
  rpc.Client? createClient(StreamingSession session) {
    final rpcChannel = _rpcChannelFor(session);
    if (rpcChannel == null) {
      return null;
    }
    return rpc.Client.withoutJson(rpcChannel);
  }

  /// Creates a [rpc.Server] for the given [session].
  ///
  /// Internally, this uses [channelFor] to obtain a stream channel for the
  /// session. This methods returns `null` for the same reasons as [channelFor].
  rpc.Server? createServer(
    StreamingSession session, {
    void Function(dynamic, dynamic)? onUnhandledError,
    bool strictProtocolChecks = true,
  }) {
    final rpcChannel = _rpcChannelFor(session);
    if (rpcChannel == null) {
      return null;
    }
    return rpc.Server.withoutJson(
      rpcChannel,
      onUnhandledError: onUnhandledError,
      strictProtocolChecks: strictProtocolChecks,
    );
  }

  /// Creates a [rpc.Peer] for the given [session].
  ///
  /// Internally, this uses [channelFor] to obtain a stream channel for the
  /// session. This methods returns `null` for the same reasons as [channelFor].
  rpc.Peer? createPeer(
    StreamingSession session, {
    void Function(dynamic, dynamic)? onUnhandledError,
    bool strictProtocolChecks = true,
  }) {
    final rpcChannel = _rpcChannelFor(session);
    if (rpcChannel == null) {
      return null;
    }
    return rpc.Peer.withoutJson(
      rpcChannel,
      onUnhandledError: onUnhandledError,
      strictProtocolChecks: strictProtocolChecks,
    );
  }

  StreamChannel? _rpcChannelFor(StreamingSession session) =>
      channelFor(session)?.transform(RpcStreamChannelTransformer());
}
