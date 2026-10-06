/// What the farmer is doing — chosen in Create Post and stored as an emoji
/// tag at the start of `posts.content`, so no schema change is needed and the
/// web shows it as plain text (spec §11.20).
enum PostActivity {
  planting('🌱', 'Planting'),
  harvesting('🌾', 'Harvesting'),
  selling('🛒', 'Selling'),
  question('❓', 'Question');

  const PostActivity(this.emoji, this.word);

  final String emoji;

  /// English word kept in the stored text, so the tag reads the same on the
  /// web and survives a change of app language.
  final String word;

  /// The stored prefix, e.g. `🌱 #Planting`.
  String get tag => '$emoji #$word';
}

/// A post's text split into its activity tag and the words the user typed.
typedef TaggedContent = ({PostActivity? activity, String text});

/// Adds, reads and removes the activity tag of a post's content.
abstract final class ActivityTag {
  /// Between the tag and the user's text.
  static const separator = '\n';

  /// [content] split into its tag (if it starts with one) and the rest.
  static TaggedContent parse(String content) {
    final trimmed = content.trimLeft();
    for (final activity in PostActivity.values) {
      if (!trimmed.startsWith(activity.tag)) continue;
      final rest = trimmed.substring(activity.tag.length);
      // `#Plantings…` is someone's own hashtag, not our tag.
      if (rest.isNotEmpty && rest.trimLeft().length == rest.length) continue;
      return (activity: activity, text: rest.trim());
    }
    return (activity: null, text: content.trim());
  }

  /// The user's text without any activity tag.
  static String strip(String content) => parse(content).text;

  /// [text] prefixed with the tag of [activity]. An existing tag is replaced,
  /// so applying twice never stacks tags; null removes it.
  static String apply(PostActivity? activity, String text) {
    final body = strip(text);
    if (activity == null) return body;
    return body.isEmpty ? activity.tag : '${activity.tag}$separator$body';
  }

  /// Characters the tag of [activity] adds in front of the user's text.
  static int prefixLength(PostActivity? activity) =>
      activity == null ? 0 : activity.tag.length + separator.length;
}
