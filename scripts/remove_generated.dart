import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart' as p;

import 'utils.dart';

void main(List<String> args) async {
  if (args.length != 1) {
    print(
        "Usage: [dart run] scripts/remove_generated.dart <path-to-nrs-impl-kt>");
    exit(1);
  }

  final generatedLineRegex = RegExp(r'generated\(.*\)');
  final sources = await Glob("**.kt", recursive: true)
      .list(root: p.join(args[0], "impl"))
      .asyncMap((fse) => FileSource.create(fse.path))
      .forEach((fs) async {
    fs.source.removeWhere((line) => generatedLineRegex.hasMatch(line));
    await fs.save();
  });
}
