import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whatsapp_stickers_handler_v2/whatsapp_stickers_handler_v2_platform_interface.dart';
import '../main.dart';

import '../helpers/custom_route.dart';
import '../providers/sticker_pack.dart';
import '../views/sticker_pack_details_screen.dart';

class StickerPacksListItem extends StatefulWidget {
  final StickerPack stickerPack;
  const StickerPacksListItem({Key? key, required this.stickerPack})
      : super(key: key);

  @override
  State<StickerPacksListItem> createState() => _StickerPacksListItemState();
}

class _StickerPacksListItemState extends State<StickerPacksListItem>
    with AutomaticKeepAliveClientMixin {
  Widget stickersListWidget() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.stickerPack.stickers.take(6).map((sticker) {
          print(
              "${widget.stickerPack.identifier}_${widget.stickerPack.stickers.indexOf(sticker)}");
          return FadeInImage(
            height: 50,
            placeholder: MemoryImage(kTransparentImage),
            image: CachedNetworkImageProvider(
                "${constants.baseUrl}${widget.stickerPack.identifier}/${sticker.imageFile}"),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD STICKER PACKS LIST ITEMS");
    final WhatsappStickersHandlerV2Platform _whatsappStickersHandler =
        WhatsappStickersHandlerV2Platform.instance;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: InkWell(
        // splashColor: Theme.of(context).primaryColor,
        splashColor: Colors.red,
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.of(context).push(
            CustomRoute(
                builder: (ctx) => StickerPackDetailsScreen(
                      stickerPackIdentifier: widget.stickerPack.identifier,
                    )),
            // StickerPackDetailsScreen.routeName,
            //arguments: stickerPack.identifier,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(1, 1, 1, 0.2),
                blurRadius: 10.0,
              )
            ],
            color: const Color.fromARGB(225, 255, 255, 255),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 66,
                      width: 67,
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 5,
                        right: 12,
                        bottom: 8,
                      ),
                      child: FadeInImage(
                        height: 50,
                        placeholder: MemoryImage(kTransparentImage),
                        image: CachedNetworkImageProvider(
                          "${constants.baseUrl}${widget.stickerPack.identifier}/${widget.stickerPack.trayImageFile}",
                        ),
                      )),
                  Expanded(
                    child: SizedBox(
                      height: 66,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.stickerPack.name,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            "${widget.stickerPack.publisher} • ${widget.stickerPack.stickers.length} stickers",
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ),
                  ),
                  if (widget.stickerPack.animatedStickerPack != null &&
                      widget.stickerPack.animatedStickerPack as bool)
                    const Padding(
                      padding: EdgeInsets.only(right: 5, left: 2),
                      child: SizedBox(
                        height: 66,
                        child: Icon(
                          Icons.play_circle_outline,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  // FutureBuilder(
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState != ConnectionState.done) {
                  //       return const SizedBox(
                  //         height: 66,
                  //       );
                  //     }
                  //     return SizedBox(
                  //       child: Icon(
                  //         snapshot.hasData && snapshot.data as bool
                  //             ? Icons.done
                  //             : null,
                  //         color: Colors.green,
                  //       ),
                  //       height: 66,
                  //     );
                  //   },
                  //   future: _whatsappStickersHandler
                  //       .isStickerPackInstalled(stickerPack.identifier),
                  // )
                ],
              ),
              stickersListWidget()
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
