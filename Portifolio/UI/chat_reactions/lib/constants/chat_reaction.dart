enum ChatReaction {
  smiley('Smiley', 'assets/emojis/smiley.json'),
  sad('Sad', 'assets/emojis/sad.json'),
  raisedEyebrow('Raised Eyebrow', 'assets/emojis/raised_eyebrow.json');

  final String label;
  final String assetPath;

  const ChatReaction(this.label, this.assetPath);
}
