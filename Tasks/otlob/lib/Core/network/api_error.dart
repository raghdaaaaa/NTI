String? safeApiErrorDetail(dynamic data) {
  dynamic candidate = data;
  if (data is Map) {
    candidate =
        data['message'] ??
        data['detail'] ??
        data['title'] ??
        _errorMessages(data['errors']);
  }
  if (candidate is! String || candidate.trim().isEmpty) return null;

  final detail = candidate
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll(RegExp(r'[\r\n\t]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (detail.isEmpty ||
      detail.length > 300 ||
      RegExp(
        r'(stack trace| at [\w.]+\(|dioexception)',
        caseSensitive: false,
      ).hasMatch(detail)) {
    return null;
  }

  return detail
      .replaceAll(
        RegExp(r'\bBearer\s+\S+', caseSensitive: false),
        'Bearer [redacted]',
      )
      .replaceAllMapped(
        RegExp(
          r'\b(password|(?:access[_ -]?)?token|authorization)\s*[:=]\s*(?:Bearer\s+)?[^\s,;]+',
          caseSensitive: false,
        ),
        (match) => '${match[1]}=[redacted]',
      )
      .replaceAll(
        RegExp(r'\beyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\b'),
        '[redacted token]',
      )
      .replaceAll(
        RegExp(
          r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b',
          caseSensitive: false,
        ),
        '[redacted email]',
      );
}

String? _errorMessages(dynamic errors) {
  if (errors is List) {
    return errors.whereType<String>().join(' ');
  }
  if (errors is Map) {
    final messages = <String>[];
    for (final value in errors.values) {
      if (value is List) {
        messages.addAll(value.whereType<String>());
      } else if (value is String) {
        messages.add(value);
      }
    }
    return messages.join(' ');
  }
  return null;
}
