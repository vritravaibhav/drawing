part of 'whiteboard_bloc.dart';

abstract class WhiteboardEvent extends Equatable {
  const WhiteboardEvent();

  @override
  List<Object> get props => [];
}

class PenColorChanged extends WhiteboardEvent {
  final Color color;

  const PenColorChanged(this.color);

  @override
  List<Object> get props => [color];
}

class StrokeWidthChanged extends WhiteboardEvent {
  final double width;

  const StrokeWidthChanged(this.width);

  @override
  List<Object> get props => [width];
}

class DrawingStarted extends WhiteboardEvent {
  final Offset position;

  const DrawingStarted(this.position);

  @override
  List<Object> get props => [position];
}

class DrawingInProgress extends WhiteboardEvent {
  final Offset position;

  const DrawingInProgress(this.position);

  @override
  List<Object> get props => [position];
}

class DrawingEnded extends WhiteboardEvent {
  const DrawingEnded();
}

class DrawingCleared extends WhiteboardEvent {}

class DrawingUndone extends WhiteboardEvent {}

class DrawingRedone extends WhiteboardEvent {}

class EraseModeToggled extends WhiteboardEvent {}
