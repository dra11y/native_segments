# native_segments

## Accessible segmented control (iOS) and "top" tab bar (Android) for Flutter.

This plugin provides an accessible native `UISegmentedControl` on iOS, and `TabLayout` on Android (in contrast to my `native_tab_bar` plugin, which provides a bottom navigation tab bar).

This component is often used for top-of-page navigation. The Flutter "equivalents" are the `CupertinoSegmentedControl` and `TabBar` components.

## Accessibility problems solved

Due to limitations imposed by Apple and Google in their accessibility APIs, the Flutter engine cannot currently replicate true native accessibility behavior in these components, because their "traits" are only available using the native view classes (Flutter has its own rendering engine and does not instantiate native view classes for every single type of component).

For example, the Flutter components attempt to mimic the native ones by adding the word "button" and the index of the segment ("1 of 3", etc.) to the accessibility label, which is incorrect behavior, because:

  * Braille display users expect shorthand traits such as "button" and list item numbering, because Braille displays are expensive and have a limited number of columns (usually 40 or fewer).

  * Voice Control/Voice Access users need to be able to "tap" the buttons with their voice, using only the button label, without having to speak the title plus "button 2 of 3."

  * When navigating word by word, VoiceOver and TalkBack users expect just the button title to be read, not also the word, "button," or "2 of 3," etc.

## Installation 

`flutter pub add native_segments`

## Dependencies

  * flutter
  * plugin_platform_interface
  * uuid

## Usage Example

Please see `example/lib/main.dart` for a full usage example.

```dart
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NativeSegments Example')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          NativeSegments(
            onValueChanged: (value) {
              print("#1 CHANGED VALUE: ${value}");
            },
            segments: List<NativeSegment>[
              NativeSegment(title: 'first'),
              NativeSegment(title: 'second segment long text'),
              NativeSegment(title: 'third segment'),
            ],
            style: NativeSegmentsStyle(
              backgroundColor: Colors.transparent,
              isDarkTheme: false,
              selectedSegmentColor: kPrimaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
```

## License

This plugin has a liberal MIT license to encourage accessibility in all app development. Please learn from it and use as you see fit in your own apps!

## Contributing

I would really appreciate learning who is using this plugin, and your feedback, and bugfix and feature requests. Please feel free to open an issue or pull request.

## Contributors

  * Tom Grushka, principal developer
  * Adam Campfield, accessibility UX design and testing
