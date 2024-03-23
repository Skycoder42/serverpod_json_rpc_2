import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:stream_channel/stream_channel.dart';

@immutable
class _ChannelData {
  final StreamChannelController<SerializableEntity> controller;
  final StreamSubscription<SerializableEntity> localStreamSub;

  const _ChannelData({
    required this.controller,
    required this.localStreamSub,
  });

  Future<void> close() => Future.wait([
        controller.local.sink.close(),
        localStreamSub.cancel(),
      ]);
}

/// An [Endpoint] mixin that allows access to [StreamingSession]s via a
/// [StreamChannel].
///
/// This basically wraps serverpod's stream APIs into session-bound stream
/// channels. Most of it happens automatically, but the following should be
/// considered:
/// 1. [StreamChannel] life cycles are managed by serverpod. If a connection
/// is closed, the [StreamChannel.stream] will emit the done event and adding
/// more messages to the[StreamChannel.sink] will have no effect.
/// 2. Closing the [StreamChannel.sink] will also close the
/// [StreamChannel.stream], but it will **not** close the websocket connection!
/// This is because multiple endpoints could be using the same connection. If
/// you need to close the connection, use the [StreamingSession.webSocket] and
/// close it directly. Please note that closing the *sink* will **not** notify
/// the client at all. Further messages received from the client will be
/// dropped.
mixin EndpointStreamChannel on Endpoint {
  final _channels = <StreamingSession, _ChannelData>{};

  /// Returns the [StreamChannel] for the given [session].
  ///
  /// Only returns a valid value if the client has previously opened a session
  /// (and thus [streamOpened] was called) and that session has been closed be
  /// neither the client nor the endpoint (via closing the sink). Otherwise
  /// `null` is returned.
  @nonVirtual
  StreamChannel<SerializableEntity>? channelFor(StreamingSession session) =>
      _channels[session]?.controller.foreign;

  @override
  @mustCallSuper
  Future<void> streamOpened(StreamingSession session) async {
    final controller = StreamChannelController<SerializableEntity>(
      allowForeignErrors: false,
    );
    _channels[session] = _ChannelData(
      controller: controller,
      localStreamSub: controller.local.stream.listen(
        (event) => sendStreamMessage(session, event),
        onDone: () => _cleanup(session),
      ),
    );
  }

  @override
  @mustCallSuper
  Future<void> streamClosed(StreamingSession session) => _cleanup(session);

  @override
  @nonVirtual
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableEntity message,
  ) async {
    final channel = _channels[session];
    if (channel != null) {
      channel.controller.local.sink.add(message);
    } else {
      session.log(
        'Dropping received stream message, channel has already been closed!',
        level: LogLevel.debug,
      );
    }
  }

  Future<void> _cleanup(StreamingSession session) async =>
      _channels.remove(session)?.close();
}
