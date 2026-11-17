import 'package:jolt_setup/jolt_setup.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mix/mix.dart';

import '/i18n/strings.g.dart';
import '/ui/hooks/use_notification.dart';
import '/ui/theme/app_styles.dart';
import '../../../process_bootstrap.dart';
import '../../widgets/process_modification_dialog.dart';
import '../../widgets/processes_data_grid/processes_data_grid.dart';

class ProcessesScreen extends SetupWidget<ProcessesScreen> {
  const ProcessesScreen({super.key});

  @override
  setup(context, props) {
    final showError = useNotification();
    final processStore = processStoreProvider.of(context);

    Future<void> addProcess() async {
      final addFailedMessage = context.tr.processes.errors.addFailed;

      final process = await showDialog<ProcessForm>(
        context: context,
        builder: (_) => ProcessModificationDialog(
          dialogTitle: context.tr.processes.dialog.addTitle,
          submitLabel: context.tr.common.add,
        ),
      );

      if (process == null) return;

      try {
        await processStore.add(
          name: process.name,
          launchType: process.launchType,
          executable: process.executable,
          arguments: process.arguments,
          environment: process.environment,
        );
      } catch (_) {
        showError(addFailedMessage);
      }
    }

    return () {
      final tr = context.tr;

      return Scaffold(
        appBar: AppBar(
          title: StyledText(tr.processes.title),
          actions: [
            FilledButton.icon(
              onPressed: processStore.isLoading ? null : addProcess,
              icon: const Icon(Icons.add_rounded),
              label: StyledText(tr.common.add),
            ),
          ],
          actionsPadding: const .symmetric(horizontal: 16),
        ),
        body: Box(style: AppStyles.page, child: const ProcessesDataGrid()),
      );
    };
  }
}
