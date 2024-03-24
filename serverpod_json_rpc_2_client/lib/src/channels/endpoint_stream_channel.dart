import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:stream_channel/stream_channel.dart';

/// An extensions for generic [EndpointRef]s that allows to access the endpoints
/// websocket connection via a [StreamChannel].
///
/// This basically wraps serverpod's stream APIs into endpoint-bound stream
/// channels. Most of it happens automatically, but the following should be
/// considered:
/// 1. The endpoint is **not** responsible for managing the underlying websocket
/// connection. This is done by the [client]. Use
/// [ServerpodClientShared.openStreamingConnection] to connect to the server
/// *before* accessing the endpoints stream channel. Likewise, use
/// [ServerpodClientShared.closeStreamingConnection] to close it once finished.
/// 2. If any side closes the connection, the [StreamChannel.stream] will emit
/// the done event and adding more messages to the[StreamChannel.sink] will have
/// no effect.
/// 3. Closing the [StreamChannel.sink] will also close the
/// [StreamChannel.stream], but it will **not** close the websocket connection!
/// This is because multiple endpoints could be using the same connection. If
/// you need to close the connection, use
/// 4. It is allowed to call [createStreamChannel] before
/// [ServerpodClientShared.openStreamingConnection]. However, in that case you
/// **must not** add any messages to the [StreamChannel.sink] before doing so.
/// [ServerpodClientShared.closeStreamingConnection]. Please note that closing
/// the *sink* will **not** notify the server at all. Further messages received
/// from the server will be silently dropped.
extension EndpointStreamChannel on EndpointRef {
  /// Creates a new [StreamChannel] for the endpoint.
  ///
  /// If a previous channel already exists it will be closed, meaning the
  /// [StreamChannel.stream] will emit the done event and adding more messages
  /// to the[StreamChannel.sink] will have no effect.
  StreamChannel<SerializableEntity> createStreamChannel() {
    resetStream();

    final controller = StreamChannelController<SerializableEntity>(
      allowForeignErrors: false,
    );
    unawaited(_setupController(controller));
    return controller.foreign;
  }

  Future<void> _setupController(
    StreamChannelController<SerializableEntity> controller,
  ) async {
    final localStreamSub = controller.local.stream.listen(
      sendStreamMessage,
      onDone: resetStream,
    );
    try {
      await stream.pipe(controller.local.sink);

      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      controller.local.sink.addError(e, s);
      await controller.local.sink.close();
    } finally {
      await localStreamSub.cancel();
    }
  }
}
