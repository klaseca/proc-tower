import 'package:jolt/jolt.dart';

class ProcessLogs {
  final entries = ListSignal<String>([]);
  final _maxBufferChars = 256 * 1024;
  var _bufferChars = 0;

  void append(String message, {DateTime? timestamp}) {
    final logTimestamp = timestamp ?? DateTime.now();
    final hh = logTimestamp.hour.toString().padLeft(2, '0');
    final mm = logTimestamp.minute.toString().padLeft(2, '0');
    final ss = logTimestamp.second.toString().padLeft(2, '0');
    final line = '[$hh:$mm:$ss] $message';

    _addLine(line);
  }

  void clear() {
    entries.clear();
    _bufferChars = 0;
  }

  void _addLine(String line) {
    batch(() {
      entries.add(line);
      _bufferChars += line.length;

      if (_bufferChars <= _maxBufferChars) {
        return;
      }

      var removeCount = 0;

      while (removeCount < entries.length && _bufferChars > _maxBufferChars) {
        _bufferChars -= entries[removeCount].length;
        removeCount += 1;
      }

      entries.removeRange(0, removeCount);
    });
  }
}
