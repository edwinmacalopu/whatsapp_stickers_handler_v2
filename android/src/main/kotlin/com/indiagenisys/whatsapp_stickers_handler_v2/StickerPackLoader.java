package com.indiagenisys.whatsapp_stickers_handler_v2;import static com.indiagenisys.whatsapp_stickers_handler_v2.provider.StickerContentProvider.STICKERS;import static com.indiagenisys.whatsapp_stickers_handler_v2.provider.StickerContentProvider.STICKERS_ASSET;import static com.indiagenisys.whatsapp_stickers_handler_v2.provider.StickerContentProvider.STICKER_FILE_EMOJI_IN_QUERY;import static com.indiagenisys.whatsapp_stickers_handler_v2.provider.StickerContentProvider.STICKER_FILE_NAME_IN_QUERY;import android.content.ContentResolver;import android.content.Context;import android.content.res.AssetFileDescriptor;import android.content.res.AssetManager;import android.database.Cursor;import android.net.Uri;import android.os.ParcelFileDescriptor;import android.text.TextUtils;import android.util.Log;import androidx.annotation.NonNull;import com.indiagenisys.whatsapp_stickers_handler_v2.provider.StickerContentProvider;import java.io.ByteArrayOutputStream;import java.io.File;import java.io.FileNotFoundException;import java.io.IOException;import java.io.InputStream;import java.util.ArrayList;import java.util.Arrays;import java.util.List;public class StickerPackLoader {    @NonNull    private static List<Sticker> getStickersForPack(Context context, StickerPack stickerPack) {        final List<Sticker> stickers = fetchFromContentProviderForStickers(stickerPack.identifier, context);        for (Sticker sticker : stickers) {            final byte[] bytes;            try {                bytes = fetchStickerAsset(stickerPack.identifier, sticker.imageFileName, context);                if (bytes.length <= 0) {                    throw new IllegalStateException("Asset file is empty, pack: " + stickerPack.name + ", sticker: " + sticker.imageFileName);                }                sticker.setSize(bytes.length);            } catch (IOException | IllegalArgumentException e) {                throw new IllegalStateException("Asset file doesn't exist. pack: " + stickerPack.name + ", sticker: " + sticker.imageFileName, e);            }        }        return stickers;    }    static byte[] fetchStickerAsset(@NonNull final String identifier, @NonNull final String name, Context context) throws IOException {        InputStream inputStream = fetchFile(context,identifier, name).createInputStream();        final ByteArrayOutputStream buffer = new ByteArrayOutputStream();        if (inputStream == null) {            String stickerFileName = name.replace("_SSP_", File.separator);            stickerFileName = stickerFileName.replace("._.", File.separator);            throw new IOException("cannot read sticker asset:" + stickerFileName);        }        int read;        byte[] data = new byte[16384];        while ((read = inputStream.read(data, 0, data.length)) != -1) {            buffer.write(data, 0, read);        }        return buffer.toByteArray();    }    static private AssetFileDescriptor fetchFile(Context context, String identifier, @NonNull final String fileName) {        File file = new File( context.getApplicationInfo().dataDir + "/app_flutter/" + STICKERS + "/" + identifier + "/", fileName);        try {            return new AssetFileDescriptor(ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY), 0,                    AssetFileDescriptor.UNKNOWN_LENGTH);        } catch (FileNotFoundException e) {            Log.e("error",                    "IOException when getting asset file:" + fileName, e);            return null;        }    }    @NonNull    private static List<Sticker> fetchFromContentProviderForStickers(String identifier, Context context) {        Uri uri = getStickerListUri(context, identifier);        ContentResolver contentResolver = context.getContentResolver();        final String[] projection = {STICKER_FILE_NAME_IN_QUERY, STICKER_FILE_EMOJI_IN_QUERY};        final Cursor cursor = contentResolver.query(uri, projection, null, null, null);        List<Sticker> stickers = new ArrayList<>();        if (cursor != null && cursor.getCount() > 0) {            cursor.moveToFirst();            do {                final String name = cursor.getString(cursor.getColumnIndexOrThrow(STICKER_FILE_NAME_IN_QUERY));                final String emojisConcatenated = cursor.getString(cursor.getColumnIndexOrThrow(STICKER_FILE_EMOJI_IN_QUERY));                List<String> emojis = new ArrayList<>(StickerPackValidator.EMOJI_MAX_LIMIT);                if (!TextUtils.isEmpty(emojisConcatenated)) {                    emojis = Arrays.asList(emojisConcatenated.split(","));                }                stickers.add(new Sticker(name, emojis));            } while (cursor.moveToNext());        }        if (cursor != null) {            cursor.close();        }        return stickers;    }    static Uri getStickerListUri(Context context, String identifier) {        return new Uri.Builder().scheme(ContentResolver.SCHEME_CONTENT).authority(WhatsappStickersHandlerV2Plugin.getContentProviderAuthority(context)).appendPath(STICKERS).appendPath(identifier).build();    }}