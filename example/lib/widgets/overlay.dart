import '../providers/sticker_pack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Overlay extends ModalRoute<void> {
  StickerPack sp;
  Overlay({required this.sp});

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: SafeArea(
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Downloading stickers',
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
          ChangeNotifierProvider.value(
            value: sp,
            child: Consumer<StickerPack>(builder: (_, stickerPack, __) {
              // if (stickerPack.downloadProgress == "100") {
              //   // Future.delayed(const Duration(milliseconds: 1)).then((value) {
              //   //   //Navigator.of(context).pop();
              //   // });
              // }
              var per = stickerPack.downloadProgress == null
                  ? 0
                  : double.parse(stickerPack.downloadProgress.toString());
              return Text(
                "${per.toStringAsFixed(0)} %",
                style: const TextStyle(color: Colors.white, fontSize: 24.0),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
