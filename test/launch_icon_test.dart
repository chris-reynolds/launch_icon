// import 'dart:io';

import 'package:launch_icon/launch_icon.dart';
import 'package:test/test.dart';

void main() async {
  test('load 2 sections from yaml file', () {
    var sections = loadAndValidatePubspecYaml();
    expect(sections.length, 2);
  });
  test('can load png', () {
    var img = loadSourceImage('test/assets/album_icon.jpg');
    expect(img.length, 512 * 512);
  });
  test('can load png', () {
    var img = loadSourceImage('test/assets/album_icon2.png');
    expect(img.length, 512 * 491);
  });
}
