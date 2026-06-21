import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Ulashish kartasi turi.
enum ShareCardType {
  achievement,
  streak,
  referral,
  challenge,
  profile,
}

/// Share card matn payload.
class ShareCardData {
  const ShareCardData({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.emoji,
    this.statLine,
    this.inviteCode,
    this.isPremium = false,
  });

  final ShareCardType type;
  final String title;
  final String subtitle;
  final String emoji;
  final String? statLine;
  final String? inviteCode;
  final bool isPremium;
}

class ShareCardService {
  /// Vizual share card widget.
  static Widget buildCard(ShareCardData data, {required Brightness brightness}) {
    final gradient = data.isPremium
        ? const [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)]
        : const [Color(0xFF6366F1), Color(0xFF4F46E5)];

    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(data.emoji, style: const TextStyle(fontSize: 36)),
              const Spacer(),
              if (data.isPremium)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          if (data.statLine != null) ...[
            const SizedBox(height: 12),
            Text(
              data.statLine!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (data.inviteCode != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Kod: ${data.inviteCode}',
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'REJABON AI',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  static String buildShareText(ShareCardData data) {
    final buffer = StringBuffer()
      ..writeln('${data.emoji} ${data.title}')
      ..writeln(data.subtitle);
    if (data.statLine != null) buffer.writeln(data.statLine);
    if (data.inviteCode != null) buffer.writeln('Taklif kodi: ${data.inviteCode}');
    buffer.writeln('\n#REJABONAI');
    return buffer.toString();
  }

  static Future<void> shareText(ShareCardData data) async {
    await Share.share(buildShareText(data));
  }

  static Future<void> shareImage(GlobalKey boundaryKey, ShareCardData data) async {
    try {
      final bytes = await _captureWidget(boundaryKey);
      if (bytes == null) {
        await shareText(data);
        return;
      }
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/rejabon_share_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: buildShareText(data),
      );
    } catch (_) {
      await shareText(data);
    }
  }

  static Future<Uint8List?> _captureWidget(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return null;
    final boundary = context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
