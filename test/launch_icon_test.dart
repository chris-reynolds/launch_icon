import 'package:launch_icon/launch_icon.dart';
import 'package:test/test.dart';

void main() {
  test('load 2 sections', () {
    var sections = loadAndValidatePubspecYaml();
    expect(sections.length, 2);
  });
}
