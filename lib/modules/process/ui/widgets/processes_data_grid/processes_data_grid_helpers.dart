import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jolt_setup/hooks.dart';
import 'package:jolt_setup/jolt_setup.dart';
import 'package:trina_grid/trina_grid.dart';

import '/i18n/strings.g.dart';
import '/ui/trina_grid/trina_grid_columns.dart';
import '../../../domain/process.dart';
import '../../process_ui_labels.dart';

typedef ProcessColumnRendererContext = ColumnRendererContext<Process, dynamic>;

typedef ProcessAction = void Function(ProcessColumnRendererContext);

typedef ProcessLogsExpandedGetter = bool Function(String);

typedef ToggleProcessLogs = void Function(String);

List<TrinaColumn> createProcessesDataGridColumns({
  required Translations tr,
  required ProcessLogsExpandedGetter isProcessLogsExpanded,
  required ToggleProcessLogs onToggleProcessLogs,
  required ProcessAction onStartProcess,
  required ProcessAction onStopProcess,
  required ProcessAction onEditProcess,
  required ProcessAction onDeleteProcess,
}) {
  final actionButtonStyle = IconButton.styleFrom(
    padding: .zero,
    minimumSize: const .square(32),
    maximumSize: const .square(32),
    tapTargetSize: .shrinkWrap,
    visualDensity: .compact,
  );

  return ColumnCreator<Process>()
      .add(
        title: tr.processes.table.name,
        field: 'name',
        type: .text(),
        renderer: (context, rendererContext) {
          final process = rendererContext.data;
          final isExpanded = isProcessLogsExpanded(process.id);

          return Row(
            spacing: 12,
            children: [
              IconButton(
                onPressed: () => onToggleProcessLogs(process.id),
                padding: .zero,
                visualDensity: .compact,
                iconSize: 24,
                icon: Icon(
                  isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.chevron_right_rounded,
                ),
              ),
              Expanded(
                child: Text(
                  rendererContext.cellValue.value,
                  overflow: .ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: .w600),
                ),
              ),
            ],
          );
        },
        valueGetter: (process) => process.name,
      )
      .add(
        title: tr.processes.table.status,
        field: 'status',
        type: .custom(),
        renderer: (context, rendererContext) {
          final status = rendererContext.cellValue.value;
          final statusTheme = _statusTheme(context, status);

          return Align(
            alignment: .centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: statusTheme.background,
                borderRadius: .circular(999),
              ),
              child: Padding(
                padding: const .symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  status.label,
                  style: TextStyle(color: statusTheme.foreground, fontWeight: .w600),
                ),
              ),
            ),
          );
        },
        valueGetter: (process) => process.status,
      )
      .add(
        title: tr.processes.table.launchType,
        field: 'launchType',
        type: .custom(),
        formatter: (value) => value.value.label,
        valueGetter: (process) => process.launchType,
      )
      .add(
        title: tr.processes.table.actions,
        field: 'actions',
        type: .text(),
        enableSorting: false,
        suppressedAutoSize: true,
        renderer: (context, rendererContext) {
          final status = rendererContext.data.status.value;
          final showStartAction = status != .running && status != .starting;

          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (showStartAction)
                IconButton.filledTonal(
                  style: actionButtonStyle,
                  onPressed: () => onStartProcess(rendererContext),
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                )
              else
                IconButton.filledTonal(
                  style: actionButtonStyle,
                  onPressed: () => onStopProcess(rendererContext),
                  icon: const Icon(Icons.stop_rounded, size: 18),
                ),
              IconButton.filledTonal(
                style: actionButtonStyle.merge(
                  _getButtonStyleColors(context, Theme.of(context).colorScheme.tertiary),
                ),
                onPressed: () => onEditProcess(rendererContext),
                icon: const Icon(Icons.edit_outlined, size: 18),
              ),
              IconButton.filledTonal(
                style: actionButtonStyle.merge(
                  _getButtonStyleColors(context, Theme.of(context).colorScheme.error),
                ),
                onPressed: () => onDeleteProcess(rendererContext),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
              ),
            ],
          );
        },
      )
      .build();
}

RowWrapper createProcessesDataGridRowWrapper(ProcessLogsExpandedGetter isProcessLogsExpanded) {
  return (_, rowWidget, rowData, _) => SetupBuilder(
    key: ValueKey(rowData.key),
    setup: (context) {
      final logsScrollController = useScrollController();

      return () {
        final tr = context.tr;
        final process = rowData.data as Process;

        if (!isProcessLogsExpanded(process.id)) {
          return rowWidget;
        }

        final colorScheme = Theme.of(context).colorScheme;
        final logs = process.logs.entries.value;
        final logsText = logs.isEmpty ? tr.processes.table.logsEmpty : logs.join('\n');

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            rowWidget,
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                border: .fromLTRB(bottom: BorderSide(color: colorScheme.outlineVariant)),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerSignal: (event) {
                    if (event is! PointerScrollEvent ||
                        !logsScrollController.hasClients ||
                        logsScrollController.position.maxScrollExtent <= 0) {
                      return;
                    }

                    GestureBinding.instance.pointerSignalResolver.register(event, (resolvedEvent) {
                      final scrollEvent = resolvedEvent as PointerScrollEvent;
                      logsScrollController.position.pointerScroll(scrollEvent.scrollDelta.dy);
                    });
                  },
                  child: Padding(
                    padding: const .all(16),
                    child: Scrollbar(
                      controller: logsScrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: logsScrollController,
                        child: SelectableText(
                          logsText,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontFamily: 'monospace',
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      };
    },
  );
}

({Color foreground, Color background}) _statusTheme(BuildContext context, ProcessStatus status) {
  final colors = Theme.of(context).colorScheme;

  return switch (status) {
    .running => (foreground: colors.onPrimaryContainer, background: colors.primaryContainer),
    .starting => (foreground: colors.onTertiaryContainer, background: colors.tertiaryContainer),
    .stopped => (foreground: colors.onSurfaceVariant, background: colors.surfaceContainerHighest),
    .failed => (foreground: colors.onErrorContainer, background: colors.errorContainer),
  };
}

ButtonStyle _getButtonStyleColors(BuildContext context, Color color) {
  final redScheme = ColorScheme.fromSeed(
    seedColor: color,
    brightness: Theme.of(context).brightness,
  );

  return IconButton.styleFrom(
    backgroundColor: redScheme.secondaryContainer,
    foregroundColor: redScheme.onSecondaryContainer,
  );
}

List<TrinaRow> createProcessesDataGridRows(List<Process> processes, List<TrinaColumn> columns) {
  return processes
      .map(
        (process) => TrinaRow(
          cells: {
            for (final column in columns)
              column.field: TrinaCell(value: column.metadata?['valueGetter']?.call(process)),
          },
          data: process,
        ),
      )
      .toList();
}

TrinaGridConfiguration createProcessesDataGridConfiguration(
  BuildContext context,
  bool isAlwaysShownScrollbar,
) {
  final colorScheme = Theme.of(context).colorScheme;
  final baseStyle = Theme.of(context).brightness == .dark
      ? const TrinaGridStyleConfig.dark()
      : const TrinaGridStyleConfig();

  return TrinaGridConfiguration(
    selectingMode: .none,
    columnSize: const TrinaGridColumnSizeConfig(autoSizeMode: .scale),
    scrollbar: TrinaGridScrollbarConfig(
      isAlwaysShown: isAlwaysShownScrollbar,
      showTrack: true,
      thumbColor: colorScheme.outline,
      trackColor: colorScheme.surfaceContainerHighest,
    ),
    style: baseStyle.copyWith(
      enableColumnBorderVertical: false,
      enableCellBorderVertical: false,
      gridBorderColor: colorScheme.outlineVariant,
      gridBackgroundColor: colorScheme.surfaceContainer,
      gridBorderRadius: .circular(16),
      gridBorderWidth: 1,
      columnHeight: 50,
      columnAscendingIcon: const TrinaOptional(Icon(Icons.arrow_downward)),
      columnDescendingIcon: const TrinaOptional(Icon(Icons.arrow_upward)),
      rowHeight: 44,
      rowColor: colorScheme.surfaceContainer,
      borderColor: colorScheme.outlineVariant,
      inactivatedBorderColor: Colors.transparent,
      activatedBorderColor: Colors.transparent,
      activatedColor: colorScheme.primary.withValues(alpha: 0.08),
      defaultCellPadding: const .symmetric(horizontal: 16),
      defaultColumnTitlePadding: const .symmetric(horizontal: 16),
    ),
  );
}
