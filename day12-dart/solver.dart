import 'dart:collection';
import 'dart:io';

int part1(Map<String, List<String>> caves, String from, String to,
    [List<String>? current]) {
  var n = 0;
  current ??= [];

  current.add(from);

  if (from == to) {
    return 1;
  }

  var next = caves[from];

  if (next == null) return 0;

  for (var path in next) {
    if (path == 'start') continue;
    if (current.last == path) continue;
    if (current.contains(path) && path.toLowerCase() == path) continue;
    n += part1(caves, path, to, List.of(current));
  }

  return n;
}

int part2(Map<String, List<String>> caves, String from, String to,
    [List<String>? current, String? dup]) {
  var n = 0;
  current ??= [];

  current.add(from);

  if (from == to) {
    return 1;
  }

  var next = caves[from];

  if (next == null) return 0;

  for (var path in next) {
    if (path == 'start') continue;
    if (current.last == path) continue;
    if (current.contains(path) && path.toLowerCase() == path) {
      if (dup == null) {
        n += part2(caves, path, to, List.of(current), path);
      }
      continue;
    }
    n += part2(caves, path, to, List.of(current), dup);
  }

  return n;
}

Future<void> main(List<String> arguments) async {
  var file = File('input.txt');

  var lines = await file.readAsLines();

  Map<String, List<String>> caves = HashMap();

  for (var line in lines) {
    var se = line.split('-');

    if (!caves.containsKey(se[0])) {
      caves[se[0]] = List.empty(growable: true);
    }

    if (!caves.containsKey(se[1])) {
      caves[se[1]] = List.empty(growable: true);
    }

    caves[se[0]]?.add(se[1]);
    caves[se[1]]?.add(se[0]);
  }
  print('Part 1 : ' + part1(caves, 'start', 'end').toString());
  print('Part 2 : ' + part2(caves, 'start', 'end').toString());
}
