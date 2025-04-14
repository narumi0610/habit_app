import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// アプリリンクのプロバイダー
final appLinksProvider = Provider<AppLinks>((ref) => AppLinks());

// アプリリンクのストリームを提供するプロバイダー
final appLinksStateProvider = StreamProvider<Uri?>((ref) {
  final appLinks = ref.read(appLinksProvider);
  // 継続的にURLの変更を監視
  return appLinks.uriLinkStream;
});
