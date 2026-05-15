import 'package:flutter/widgets.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:trina_grid/trina_grid.dart';

typedef Renderer<T, U> = Widget Function(BuildContext, ColumnRendererContext<T, U>);

typedef Formatter<T> = String Function(T);

typedef ValueGetter<T, U> = U Function(T);

class ColumnCreator<T> {
  final List<TrinaColumn> _columns = [];

  ColumnCreator<T> add<U>({
    required String title,
    required String field,
    required TrinaColumnType type,
    bool enableSorting = true,
    bool suppressedAutoSize = false,
    Renderer<T, U>? renderer,
    Formatter<U>? formatter,
    ValueGetter<T, U>? valueGetter,
  }) {
    _columns.add(
      TrinaColumn(
        title: title,
        field: field,
        type: type,
        readOnly: true,
        enableColumnDrag: false,
        enableContextMenu: false,
        enableSorting: enableSorting,
        suppressedAutoSize: suppressedAutoSize,
        renderer: renderer != null || formatter != null
            ? (rendererContext) => SetupBuilder(
                setup: (context) => () {
                  if (renderer != null) {
                    return renderer(context, ColumnRendererContext.from(rendererContext));
                  }

                  return Text(
                    formatter!(rendererContext.cell.value),
                    overflow: .ellipsis,
                    textAlign: rendererContext.column.textAlign.value,
                  );
                },
              )
            : null,
        metadata: {'valueGetter': valueGetter},
      ),
    );

    return this;
  }

  List<TrinaColumn> build() {
    return _columns;
  }
}

class ColumnRendererContext<T, U> extends TrinaColumnRendererContext {
  ColumnRendererContext({
    required super.column,
    required super.rowIdx,
    required super.row,
    required super.cell,
    required super.stateManager,
  });

  T get data => row.data as T;

  U get cellValue => cell.value as U;

  factory ColumnRendererContext.from(TrinaColumnRendererContext context) {
    return ColumnRendererContext(
      column: context.column,
      cell: context.cell,
      row: context.row,
      rowIdx: context.rowIdx,
      stateManager: context.stateManager,
    );
  }
}
