import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/whiteboard_bloc.dart';
import 'whiteboard_painter.dart';

class WhiteboardScreen extends StatelessWidget {
  const WhiteboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              context.read<WhiteboardBloc>().add(
                DrawingStarted(details.localPosition),
              );
            },
            onPanUpdate: (details) {
              context.read<WhiteboardBloc>().add(
                DrawingInProgress(details.localPosition),
              );
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    context.read<WhiteboardBloc>().add(EraseModeToggled()),
                color: context.watch<WhiteboardBloc>().state.isErasing
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              const _ColorPalette(),
              const _StrokeSlider(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorPalette extends StatelessWidget {
  const _ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ColorButton(color: Colors.black),
        _ColorButton(color: Colors.red),
        _ColorButton(color: Colors.green),
        _ColorButton(color: Colors.blue),
      ],
    );
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;

  const _ColorButton({required this.color});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WhiteboardBloc>().state;
    final isSelected = state.penColor == color && !state.isErasing;

    return GestureDetector(
      onTap: () => context.read<WhiteboardBloc>().add(PenColorChanged(color)),
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
      ),
    );
  }
}

class _StrokeSlider extends StatelessWidget {
  const _StrokeSlider();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WhiteboardBloc>().state;

    return Slider(
      value: state.strokeWidth,
      min: 1.0,
      max: 20.0,
      onChanged: (width) =>
          context.read<WhiteboardBloc>().add(StrokeWidthChanged(width)),
    );
  }
}
