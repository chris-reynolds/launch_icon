import 'dart:io';
import 'package:image/image.dart';
import 'package:yaml/yaml.dart';

/// main entry of command line utility
/// It loads the pubspec.yaml sections looking for source and target file specifications.
/// For each file that matches a target file specitication, it will be overwritten with a
/// resized version of the source icon.
void driver(List<String> arguments) {
  try {
    var iconSectionList = loadAndValidatePubspecYaml();
    var fullFileList = Directory('.').listSync(recursive: true);
    for (var iconSection in iconSectionList) {
      String source = iconSection['source'];
      List<dynamic> targets = iconSection['target'].toList();
      print('\nLaunch Icon : $source \n to  $targets}!');
      var sourceImg = loadSourceImage(source);
      for (var target in targets) {
        var fileList =
            fullFileList.where((element) => matchPaths(element.path, target));
        if (fileList.isEmpty) print('No files matching $target');
        for (var targetFile in fileList) {
          replaceIcon(sourceImg, targetFile.path);
        } // for each file
      } // of each wildcard target
    } // of each section
  } catch (ex) {
    print('EXCEPTION $ex');
  }
}

// PRIVATE
// Functions below here are public only to allow unit testing.

/// loadSourceImage() takes a filename and loads the file contents into an Image object for later resizing
Image loadSourceImage(String fileName) {
  var imgFile = File(fileName);
  if (!imgFile.existsSync()) throw '$fileName does not exist as source image';
  var img = decodeImage(imgFile.readAsBytesSync());
  if (img == null) throw '$fileName is not a recognizable image';
  return img;
} // of loadSourceImage

/// matchPaths() checks to see if the current file matches a wildcard specification
/// [currentFilename] is the current filename being checked and [wantedRegex] is the mask being compared to it.
/// Note that asterisks are replaced by dot-asterisk before the wild card matching for user simplicity (I hope).
bool matchPaths(String currentFilename, String wantedRegex) {
  if (currentFilename.isEmpty || wantedRegex.isEmpty) return false;
  currentFilename = currentFilename.replaceAll('\\', '/');
  wantedRegex = wantedRegex.replaceAll('*', '.*').replaceAll('?', '.');
  if (currentFilename.startsWith('./'))
    currentFilename = currentFilename.substring(2); // strip ./
  var wantedMask = RegExp('$wantedRegex', dotAll: true);
  var match = wantedMask.stringMatch(currentFilename);
  return match != null;
} // of matchPaths

const PUBSPEC = 'pubspec.yaml';

/// loadAndValidatePubspecYaml() loads the local pubspec.yaml, extracts the relevant launch_icon sections
/// and checks that they contain a source and a target list.
/// Note that [yamlFilename] is only normally used to ease testing.
List<dynamic> loadAndValidatePubspecYaml({yamlFilename = PUBSPEC}) {
  var sectionList = <dynamic>[];
  if (!File(yamlFilename).existsSync())
    throw 'Must be in root of flutter project';
  try {
    dynamic fullYaml = loadYaml(File(yamlFilename).readAsStringSync());
    for (var iconSection in fullYaml.entries) {
      //      dynamic iconSection = fullYaml['launch_icon'];
      if (iconSection.key.startsWith('launch_icon')) {
        if (iconSection.value['source'] == null) {
          throw 'No source specified for ${iconSection.key} in $yamlFilename';
        }
        if (iconSection.value['target'] == null) {
          throw 'No target specified for ${iconSection.key} in $yamlFilename';
        }
        sectionList.add(iconSection.value);
      }
    }
    if (sectionList.isEmpty)
      throw 'launch_icon section is missing from $PUBSPEC';
    return sectionList;
  } catch (ex) {
    throw 'Failed to parse $PUBSPEC \n$ex';
  }
} // of loadAndValidatePubspecYaml

/// replaceIcon() is used when a target icon is found. It gets the size from the target and then rewrites it
/// with a resized version of the source.
void replaceIcon(Image sourceImg, String targetFile) {
  var targetImg = decodeImage(File(targetFile).readAsBytesSync());
  if (targetImg == null) print('Unrecognised image ${targetFile}');
  var newImage =
      copyResize(sourceImg, width: targetImg!.width, height: targetImg.height);
  var newBytes = encodeNamedImage(targetFile, newImage)!.toList();
  File(targetFile).writeAsBytesSync(newBytes);
  print('replaced $targetFile');
} // of replaceIcon
