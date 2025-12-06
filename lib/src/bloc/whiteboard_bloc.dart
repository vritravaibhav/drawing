import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/drawing_model.dart';

part 'whiteboard_event.dart';
part 'whiteboard_state.dart';

class WhiteboardBloc extends Bloc<WhiteboardEvent, WhiteboardState> {
  WhiteboardBloc() : super(const WhiteboardState()) {
    on<PenColorChanged>(_onPenColorChanged);
    on<StrokeWidthChanged>(_onStrokeWidthChanged);
    on<DrawingStarted>(_onDrawingStarted);
    on<DrawingInProgress>(_onDrawingInProgress);
    on<DrawingEnded>(_onDrawingEnded);
    on<DrawingCleared>(_onDrawingCleared);
    on<DrawingUndone>(_onDrawingUndone);
    on<DrawingRedone>(_onDrawingRedone);
    on<EraseModeToggled>(_onEraseModeToggled);
  }

  void _onPenColorChanged(
      PenColorChanged event, Emitter<WhiteboardState> emit) {
        
    emit(state.copyWith(penColor: event.color, isErasing: false));
  }

  void _onStrokeWidthChanged(
      StrokeWidthChanged event, Emitter<WhiteboardState> emit) {
    emit(state.copyWith(strokeWidth: event.width));
  }

  void _onDrawingStarted(DrawingStarted event, Emitter<WhiteboardState> emit) {
    final newDrawing = Drawing(
      points: [event.position],
      color: state.isErasing ? Colors.white : state.penColor,
      strokeWidth: state.strokeWidth,
    );
    emit(state.copyWith(
      status: WhiteboardStatus.drawing,
      drawings: [...state.drawings, newDrawing],
      undoneDrawings: [],
    ));
  }

  void _onDrawingInProgress(
      DrawingInProgress event, Emitter<WhiteboardState> emit) {
    if (state.drawings.isNotEmpty) {
      final lastDrawing = state.drawings.last;
      final newPoints = [...lastDrawing.points, event.position];
      final updatedDrawing = lastDrawing.copyWith(points: newPoints);
      final newDrawings = [...state.drawings]
        ..[state.drawings.length - 1] = updatedDrawing;
      emit(state.copyWith(drawings: newDrawings));
    }
  }

  void _onDrawingEnded(DrawingEnded event, Emitter<WhiteboardState> emit) {
    emit(state.copyWith(status: WhiteboardStatus.done));
  }

  void _onDrawingCleared(DrawingCleared event, Emitter<WhiteboardState> emit) {
    emit(const WhiteboardState());
  }

  void _onDrawingUndone(DrawingUndone event, Emitter<WhiteboardState> emit) {
    if (state.drawings.isNotEmpty) {
      final lastDrawing = state.drawings.last;
      final newDrawings = state.drawings.sublist(0, state.drawings.length - 1);
      emit(state.copyWith(
        drawings: newDrawings,
        undoneDrawings: [...state.undoneDrawings, lastDrawing],
      ));
    }
  }

  void _onDrawingRedone(DrawingRedone event, Emitter<WhiteboardState> emit) {
    if (state.undoneDrawings.isNotEmpty) {
      final lastUndoneDrawing = state.undoneDrawings.last;
      final newUndoneDrawings =
          state.undoneDrawings.sublist(0, state.undoneDrawings.length - 1);
      emit(state.copyWith(
        drawings: [...state.drawings, lastUndoneDrawing],
        undoneDrawings: newUndoneDrawings,
      ));
    }
  }

  void _onEraseModeToggled(
      EraseModeToggled event, Emitter<WhiteboardState> emit) {
    emit(state.copyWith(isErasing: !state.isErasing));
  }
}
