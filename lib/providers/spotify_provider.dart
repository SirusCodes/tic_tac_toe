import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../api_keys.dart';

final connectProvider = FutureProvider<bool>((ref) {
  return ref.read(spotifyService).connect();
});

final playerState = StreamProvider.autoDispose<PlayerState>((ref) {
  return ref.read(spotifyService).subPlayerState();
});

final connectionStatusProvider =
    StreamProvider.autoDispose<ConnectionStatus>((ref) {
  return ref.read(spotifyService).connectionStatus();
});

final spotifyService = Provider<SpotifyService>((ref) {
  return SpotifyService();
});

class SpotifyService {
  Stream<ConnectionStatus> connectionStatus() =>
      SpotifySdk.subscribeConnectionStatus();

  Future<bool> connect() => SpotifySdk.connectToSpotifyRemote(
        clientId: APIKey.clientId,
        redirectUrl: APIKey.redirectUrl,
      );

  Future<bool> disconnect() => SpotifySdk.disconnect();

  Stream<PlayerState> subPlayerState() => SpotifySdk.subscribePlayerState();

  Future play(String spotifyUri) => SpotifySdk.play(spotifyUri: spotifyUri);

  Future resume() => SpotifySdk.resume();

  Future pause() => SpotifySdk.pause();

  Future next() => SpotifySdk.skipNext();

  Future previous() => SpotifySdk.skipPrevious();
}
