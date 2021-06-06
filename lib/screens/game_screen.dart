import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../providers/board_provider.dart';
import '../providers/game_state_provider.dart';
import '../providers/spotify_provider.dart';
import '../utils/players.dart';
import '../widgets/cross.dart';
import '../widgets/nought.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void dispose() {
    SpotifySdk.pause();
    SpotifySdk.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: gameStateProvider,
      onChange: (context, GameState state) {
        switch (state) {
          case GameState.player1:
            break;
          case GameState.player2:
            context.read(boardProvider.notifier).playForMachine(Machine());
            break;
          case GameState.tie:
            _showDialog(context, "It's a Tie⚔");
            break;
          case GameState.player1Won:
            _showDialog(context, "You won🎉");
            break;
          case GameState.player2Won:
            _showDialog(context, "Let's try again🔥");
            break;
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Text(
                  "You are playing as X",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Expanded(child: _GameGrid()),
              _PlayerCard(),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  result,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read(boardProvider.notifier).resetBoard();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.repeat),
                  label: Text("Restart"),
                ),
                const SizedBox(height: 5),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read(boardProvider.notifier).resetBoard();

                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.exit_to_app_rounded),
                  label: Text("Quit"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SpotifyImage extends StatelessWidget {
  const SpotifyImage({Key? key, required this.imageUri}) : super(key: key);

  final ImageUri imageUri;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SpotifySdk.getImage(
        imageUri: imageUri,
        dimension: ImageDimension.medium,
      ),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data!);
        } else if (snapshot.hasError) {
          return SizedBox(
            width: ImageDimension.medium.value.toDouble(),
            height: ImageDimension.medium.value.toDouble(),
            child: const Center(child: Text('Error getting image')),
          );
        } else {
          return SizedBox(
            width: ImageDimension.medium.value.toDouble(),
            height: ImageDimension.medium.value.toDouble(),
            child: const Center(child: Text('Getting image...')),
          );
        }
      },
    );
  }
}

class _PlayerControls extends StatelessWidget {
  _PlayerControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () => context.read(spotifyService).previous(),
          icon: Icon(Icons.skip_previous_rounded),
        ),
        IconButton(
          onPressed: () => context.read(spotifyService).resume(),
          icon: Icon(Icons.play_arrow_rounded),
        ),
        IconButton(
          onPressed: () => context.read(spotifyService).pause(),
          icon: Icon(Icons.pause_rounded),
        ),
        IconButton(
          onPressed: () => context.read(spotifyService).next(),
          icon: Icon(Icons.skip_next_rounded),
        ),
      ],
    );
  }
}

class _PlayerDetails extends ConsumerWidget {
  const _PlayerDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _playerState = watch(playerState);

    return _playerState.when(
      data: (state) {
        final track = state.track;
        if (track != null)
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SpotifyImage(imageUri: track.imageUri),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: <Widget>[
                      Text(
                        track.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        track.album.name,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      _PlayerControls()
                    ],
                  ),
                )
              ],
            ),
          );

        return Container();
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, st) => Text("Something went wrong"),
    );
  }
}

class _PlayerCard extends ConsumerWidget {
  const _PlayerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final connectionStatus = watch(connectionStatusProvider);
    return connectionStatus.when(
      data: (status) {
        return Card(
          child: const _PlayerDetails(),
        );
      },
      loading: () => ElevatedButton(
        onPressed: () {
          context.read(spotifyService).connect();
        },
        child: Text("Connect Spotify"),
      ),
      error: (err, st) {
        return Text("Something went wrong");
      },
    );
  }
}

class _GameGrid extends ConsumerWidget {
  const _GameGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final boardState = watch(boardProvider);

    return GridView.count(
      crossAxisCount: 3,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1,
      children: List.generate(
        9,
        (index) => _Field(
          onTap: () {
            context.read(boardProvider.notifier).onPlayerMove(Human(), index);
          },
          child: boardState[index] == BoardElement.none
              ? SizedBox.shrink()
              : boardState[index] == BoardElement.cross
                  ? CrossWidget()
                  : NoughtWidget(),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: child,
        ),
      ),
    );
  }
}
