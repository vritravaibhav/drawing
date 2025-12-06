part of 'whiteboard_bloc.dart';

enum WhiteboardStatus { initial, drawing, done }

class WhiteboardState extends Equatable {
  final WhiteboardStatus status;
  final List<Drawing> drawings;
  final List<Drawing> undoneDrawings;
  final Color penColor;
  final double strokeWidth;

  const WhiteboardState({
    this.status = WhiteboardStatus.initial,
    this.drawings = const [],
    this.undoneDrawings = const [],
    this.penColor = Colors.black,
    this.strokeWidth = 2.0,
  });

  WhiteboardState copyWith({
    WhiteboardStatus? status,
    List<Drawing>? drawings,
    List<Drawing>? undoneDrawings,
    Color? penColor,
    double? strokeWidth,
  }) {
    return WhiteboardState(
      status: status ?? this.status,
      drawings: drawings ?? this.drawings,
      undoneDrawings: undoneDrawings ?? this.undoneDrawings,
      penColor: penColor ?? this.penColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }

  @override
  List<Object> get props =>
      [status, drawings, undoneDrawings, penColor, strokeWidth];
}
