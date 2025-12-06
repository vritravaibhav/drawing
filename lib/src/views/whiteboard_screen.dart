import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/whiteboard_bloc.dart';
import 'whiteboard_painter.dart';

class WhiteboardScreen extends StatelessWidget {
  const WhiteboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whiteboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () =>
                context.read<WhiteboardBloc>().add(DrawingUndone()),
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: () =>
                context.read<WhiteboardBloc>().add(DrawingRedone()),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () =>
                context.read<WhiteboardBloc>().add(DrawingCleared()),
          ),
        ],
      ),
      body: BlocBuilder<WhiteboardBloc, WhiteboardState>(
        builder: (context, state) {
          return GestureDetector(
            onPanStart: (details) {
              context
                  .read<WhiteboardBloc>()
                  .add(DrawingStarted(details.localPosition));
            },
            onPanUpdate: (details) {
              context
                  .read<WhiteboardBloc>()
                  .add(DrawingInProgress(details.localPosition));
            },
            onPanEnd: (_) {
              context.read<WhiteboardBloc>().add(DrawingEnded());
            },
            child: CustomPaint(
              painter: WhiteboardPainter(state.drawings),
              size: Size.infinite,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ColorButton(color: Colors.black),
            _ColorButton(color: Colors.red),
            _ColorButton(color: Colors.green),
            _ColorButton(color: Colors.blue),
            _StrokeButton(width: 2.0),
            _StrokeButton(width: 5.0),
            _StrokeButton(width: 10.0),
          ],
        ),
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;

  const _ColorButton({required this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.circle, color: color),
      onPressed: () =>
          context.read<WhiteboardBloc>().add(PenColorChanged(color)),
    );
  }
}

class _StrokeButton extends StatelessWidget {
  final double width;

  const _StrokeButton({required this.width});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.circle, size: width * 2),
      onPressed: () =>
          context.read<WhiteboardBloc>().add(StrokeWidthChanged(width)),
    );
  }
}
