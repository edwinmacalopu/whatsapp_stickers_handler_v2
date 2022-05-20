import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import '../main.dart';
import '../providers/sticker_pack.dart';
import '../providers/sticker_packs.dart';
import '../widgets/add_to_whatsapp_button.dart';
import '../widgets/overlay.dart' as ol;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:archive/archive.dart';
import '../helpers/utils.dart';
import '../providers/google_ads.dart';

class StickerPackDetailsScreen extends StatefulWidget {
  static const String routeName = "/sticker-pack-details";
  final String stickerPackIdentifier;

  var stickersDownloading = true;
  bool directoryExists = false;
  String localPath = "";
  String dirPath = "";
  late StickerPack stickerPack;
  BannerAd? _bannerAd;

  StickerPackDetailsScreen({
    Key? key,
    required this.stickerPackIdentifier,
  }) : super(key: key);

  @override
  State<StickerPackDetailsScreen> createState() =>
      _StickerPackDetailsScreenState();
}

class _StickerPackDetailsScreenState extends State<StickerPackDetailsScreen> {
  void downloadStickers(StickerPack stickerPack) async {
    String remoteZipUrl = "${constants.baseUrl}${stickerPack.identifier}.zip";
    String tmpZipPath = "${widget.localPath}/${stickerPack.identifier}_tmp.zip";

    if (!widget.directoryExists) {
      Navigator.of(context).push(ol.Overlay(sp: stickerPack));
      Dio dio = Dio();

      try {
        await dio.download(
          remoteZipUrl,
          tmpZipPath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              var per = (received / total * 100).toStringAsFixed(0);
              stickerPack.updateDownloadProgress(per);
            }
          },
        );
      } catch (error) {
        Navigator.pop(context);
        File tmpFile = File(tmpZipPath);
        tmpFile.delete();
        return;
      }

      File tmpFile = File(tmpZipPath);
      var fExists = await tmpFile.exists();

      if (fExists) {
        var bytes = tmpFile.readAsBytesSync();
        var archive = ZipDecoder().decodeBytes(bytes);
        for (var file in archive) {
          var fileName = "${widget.localPath}/stickers/${file.name}";
          if (file.isFile) {
            var outFile = File(fileName);
            outFile = await outFile.create(recursive: true);
            await outFile.writeAsBytes(file.content);
          }
        }
      }
      if (mounted) {
        setState(() {
          widget.directoryExists = true;
        });
      }
      Navigator.of(context).pop();
      tmpFile.delete();
    }
  }

  @override
  void initState() {
    setState(() {
      widget.stickerPack = Provider.of<StickerPacks>(context, listen: false)
          .findByIdentifier(widget.stickerPackIdentifier);
      widget._bannerAd = Provider.of<GoogleAds>(
        context,
        listen: false,
      ).loadBannerAd(null);
      widget._bannerAd?.load();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    var lPath = await Utils.localPath;

    setState(() {
      widget.localPath = lPath;
      widget.dirPath =
          "${widget.localPath}/stickers/${widget.stickerPack.identifier}";
    });

    var dExists = await Directory(widget.dirPath).exists();
    setState(() {
      widget.directoryExists = dExists;
    });

    downloadStickers(widget.stickerPack);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromARGB(255, 84, 90, 105),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.stickerPack.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        "${widget.stickerPack.publisher} • ${widget.stickerPack.stickers.length} stickers",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      color: Color.fromARGB(255, 84, 90, 105),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            height: 250,
                            child: Column(
                              children: [
                                Image.file(
                                  File(
                                      "${widget.dirPath}/${widget.stickerPack.trayImageFile}"),
                                  height: 150,
                                ),
                                const Spacer(),
                                Text(
                                  widget.stickerPack.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  "${widget.stickerPack.publisher} • ${widget.stickerPack.stickers.length} stickers",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                ),
                itemCount: widget.directoryExists
                    ? widget.stickerPack.stickers.length
                    : widget.stickerPack.stickers.length >= 6
                        ? 6
                        : widget.stickerPack.stickers.length,
                itemBuilder: (context, index) {
                  ImageProvider<Object> imageProvider = widget.directoryExists
                      ? FileImage(File(
                              "${widget.dirPath}/${widget.stickerPack.stickers[index].imageFile}"))
                          as ImageProvider<Object>
                      : CachedNetworkImageProvider(
                          "${constants.baseUrl}${widget.stickerPack.identifier}/${widget.stickerPack.stickers[index].imageFile}");
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: FadeInImage(
                      height: 50,
                      placeholder: MemoryImage(kTransparentImage),
                      image: imageProvider,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AddToWhatsAppButton(
                stickerPack: widget.stickerPack,
              ),
            ),
          ],
        ),
        persistentFooterButtons: [
          SizedBox(
            height: widget._bannerAd?.size.height.toDouble(),
            child: widget._bannerAd != null
                ? AdWidget(ad: widget._bannerAd as AdWithView)
                : null,
          ),
        ],
      ),
    );
  }
}
