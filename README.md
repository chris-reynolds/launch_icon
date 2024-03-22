# launch_icon

A command-line app to help change a flutter application icon regardless of platform.

Each platform seems to have several copies of the application icon at different sizes.

The launch_icon utility searches for images in a flutter project that that match some target wild-card specification  
and then for each matching image, it reads the width and height and replaces the image  
with a clone of the source image resized to match the target.

The source and target file specifications are read from the pubspec.yaml file and any sections that start with
'launch_icon' will be examined for source and targets.

Below is simple example of an icon being push across android,ios,macos and web.
```
launch_icon:
  source: assets/sync.jpg
  target:
    - ios/Runner/*/app_icon*.png
    - macos/Runner/*/app_icon*.png
    - web/icons/Icon*.png
    - web/favicon.png
    - android/*/ic_launcher*.png 
    - windows/*/ic_launcher*.png      
        
```

If you required different icons on different platforms, the launch_icon utility
will parse multiple sections in pubspec.yaml as seen below.

```
launch_icon_ios_macos_and_web:
  source: ../aopicons/album_i_icon.png
  target:
    - ios/Runner/*/app_icon*.png
    - macos/Runner/*/app_icon*.png
    - web/*/Icon*.png
    - web/favicon.png

launch_icon_android:
  source: ../aopicons/album_a_icon.png
  target:
    - android/*/ic_launcher*.png
    
```

### Note
1. These paths were correct for Flutter 1.26.0 but of course you may need to adapt the paths as
the different platforms mature.
2. The utility must be run from the flutter project root. (i.e. a local pubspec.yaml must exist)

3. All image manipulation is courtesy of package 'image' by Brendan Duncan and those are the file types supported.

4. This utility can be installed with the command
```
 pub global activate -sgit https://github.com/chris-reynolds/launch_icon 
 ```