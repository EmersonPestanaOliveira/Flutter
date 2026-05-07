String extensionFromContentType(String contentType) {
  return switch (contentType) {
    'image/png' => 'png',
    'image/webp' => 'webp',
    _ => 'jpg',
  };
}
