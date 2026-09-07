import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

import '../data/menu_catalog.dart';
import '../models/coffee_record.dart';
import '../widgets/paper_scaffold.dart';
import '../widgets/record_card.dart';

class ShareCardScreen extends StatefulWidget {
  const ShareCardScreen({super.key, required this.record});
  final CoffeeRecord record;

  @override
  State<ShareCardScreen> createState() => _ShareCardScreenState();
}

class _ShareCardScreenState extends State<ShareCardScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _working = false;

  String get _fileName =>
      'CUPPO_${widget.record.date.year}${widget.record.date.month.toString().padLeft(2, '0')}${widget.record.date.day.toString().padLeft(2, '0')}_${widget.record.id}.png';

  @override
  Widget build(BuildContext context) {
    return PaperScaffold(
      body: Column(
        children: [
          SizedBox(
            height: 58,
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                const Spacer(),
                Text('4 : 5', style: TextStyle(fontSize: 11, letterSpacing: 1.6, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38))),
                const SizedBox(width: 22),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 264,
                child: RepaintBoundary(
                  key: _cardKey,
                  child: _ShareCard(record: widget.record),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    onPressed: _working ? null : _saveImage,
                    child: Text(_working ? '처리 중…' : '이미지 저장'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    onPressed: _working ? null : _shareImage,
                    child: const Text('공유하기'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List?> _capture() async {
    await WidgetsBinding.instance.endOfFrame;
    final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (byteData == null) return null;
    return byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
  }

  Future<void> _saveImage() async {
    setState(() => _working = true);
    try {
      final bytes = await _capture();
      if (bytes == null) throw StateError('카드 이미지를 만들 수 없습니다.');

      var access = await Gal.hasAccess(toAlbum: true);
      if (!access) access = await Gal.requestAccess(toAlbum: true);
      if (!access) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('사진 저장 권한이 필요해요.')));
        }
        return;
      }

      await Gal.putImageBytes(bytes, album: 'CUPPO', name: _fileName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CUPPO 카드 이미지를 저장했어요.')));
      }
    } on GalException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.type.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('이미지 저장 중 문제가 생겼어요.')));
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _shareImage() async {
    setState(() => _working = true);
    try {
      final bytes = await _capture();
      if (bytes == null) throw StateError('카드 이미지를 만들 수 없습니다.');
      final menu = menuByKey(widget.record.menu);
      await SharePlus.instance.share(
        ShareParams(
          text: 'CUPPO · ${menu.name} · ${formatDate(widget.record.date)}',
          files: [XFile.fromData(bytes, mimeType: 'image/png')],
          fileNameOverrides: [_fileName],
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('공유 화면을 열지 못했어요.')));
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }
}

class _ShareCard extends StatelessWidget {
  const _ShareCard({required this.record});
  final CoffeeRecord record;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFF1F0EC) : const Color(0xFF1F1F1E);
    final background = dark ? const Color(0xFF242423) : const Color(0xFFFBFBF9);
    final menu = menuByKey(record.menu);

    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        color: background,
        padding: const EdgeInsets.all(20),
        child: DefaultTextStyle(
          style: TextStyle(color: ink, fontFamily: 'sans-serif'),
          child: Column(
            children: [
              Row(
                children: [
                  Text('#${menu.name}', style: const TextStyle(fontSize: 11)),
                  const Spacer(),
                  Text(formatDate(record.date), style: TextStyle(fontSize: 10, color: ink.withValues(alpha: 0.46))),
                ],
              ),
              Expanded(
                child: Center(
                  child: Image.asset(
                    recordIllustration(record),
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  record.title.isEmpty ? menu.name : record.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CUPPO',
                  style: TextStyle(fontSize: 10, letterSpacing: 4.0, color: ink.withValues(alpha: 0.36)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
