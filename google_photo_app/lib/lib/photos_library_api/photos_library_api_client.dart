/*
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:sharing_codelab/photos_library_api/album.dart';
import 'package:http/http.dart' as http;
import 'package:sharing_codelab/photos_library_api/batch_create_media_items_request.dart';
import 'package:sharing_codelab/photos_library_api/batch_create_media_items_response.dart';
import 'package:sharing_codelab/photos_library_api/create_album_request.dart';
import 'package:sharing_codelab/photos_library_api/get_album_request.dart';
import 'package:sharing_codelab/photos_library_api/join_shared_album_request.dart';
import 'package:sharing_codelab/photos_library_api/join_shared_album_response.dart';
import 'package:sharing_codelab/photos_library_api/list_albums_response.dart';
import 'package:sharing_codelab/photos_library_api/list_shared_albums_response.dart';
import 'package:sharing_codelab/photos_library_api/search_media_items_request.dart';
import 'package:sharing_codelab/photos_library_api/search_media_items_response.dart';
import 'package:sharing_codelab/photos_library_api/share_album_request.dart';
import 'package:sharing_codelab/photos_library_api/share_album_response.dart';
import 'package:path/path.dart' as path;

class PhotosLibraryApiClient {
  PhotosLibraryApiClient(this._authHeaders);

  Future<Map<String, String>> _authHeaders;

  Future<Album> createAlbum(CreateAlbumRequest request) async {
    return http
        .post(
      'https://photoslibrary.googleapis.com/v1/albums',
      body: jsonEncode(request),
      headers: await _authHeaders,
    )
        .then(
      (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }
        return Album.fromJson(jsonDecode(response.body));
      },
    );
  }

  Future<JoinSharedAlbumResponse> joinSharedAlbum(
      JoinSharedAlbumRequest request) async {
    return http
        .post('https://photoslibrary.googleapis.com/v1/sharedAlbums:join',
            headers: await _authHeaders, body: jsonEncode(request))
        .then((Response response) {
      if (response.statusCode != 200) {
        print(response.reasonPhrase);
        print(response.body);
      }

      return JoinSharedAlbumResponse.fromJson(jsonDecode(response.body));
    });
  }

  Future<ShareAlbumResponse> shareAlbum(ShareAlbumRequest request) async {
    return http
        .post(
            'https://photoslibrary.googleapis.com/v1/albums/${request.albumId}:share',
            headers: await _authHeaders)
        .then(
      (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }

        return ShareAlbumResponse.fromJson(jsonDecode(response.body));
      },
    );
  }

  Future<Album> getAlbum(GetAlbumRequest request) async {
    return http
        .get(
            'https://photoslibrary.googleapis.com/v1/albums/${request.albumId}',
            headers: await _authHeaders)
        .then(
      (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }

        return Album.fromJson(jsonDecode(response.body));
      },
    );
  }

  Future<ListAlbumsResponse> listAlbums() async {
    return http
        .get(
            'https://photoslibrary.googleapis.com/v1/albums?'
            'pageSize=50&excludeNonAppCreatedData=true',
            headers: await _authHeaders)
        .then(
      (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }

        print(response.body);

        return ListAlbumsResponse.fromJson(jsonDecode(response.body));
      },
    );
  }

  Future<ListSharedAlbumsResponse> listSharedAlbums() async {
    return http
        .get(
            'https://photoslibrary.googleapis.com/v1/sharedAlbums?'
            'pageSize=50&excludeNonAppCreatedData=true',
            headers: await _authHeaders)
        .then(
      (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }

        print(response.body);

        return ListSharedAlbumsResponse.fromJson(jsonDecode(response.body));
      },
    );
  }

  Future<String> uploadMediaItem(File image) async {
    // 이미지 파일 이름 가져오기
    final String filename = path.basename(image.path);

    // 요청에 필요한 헤더를 설정
    final Map<String, String> headers = <String, String>{};
    headers.addAll(await _authHeaders);
    headers['Content-type'] = 'application/octet-stream';
    headers['X-Goog-Upload-Protocol'] = 'raw';
    headers['X-Goog-Upload-File-Name'] = filename;

    // 이미지를 업로드 하려면 HTTP 요청을 하세요. 파일은 body 로 전송
    return http
        .post(
      'https://photoslibrary.googleapis.com/v1/uploads',
      body: image.readAsBytesSync(),
      headers: await _authHeaders,
    )
        .then((Response response) {
      if (response.statusCode != 200) {
        print(response.reasonPhrase);
        print(response.body);
      }

      return response.body;
    });
  }

  Future<SearchMediaItemsResponse> searchMediaItems(
      SearchMediaItemsRequest request) async {
    return http
        .post(
      'https://photoslibrary.googleapis.com/v1/mediaItems:search',
      body: jsonEncode(request),
      headers: await _authHeaders,
    )
        .then(
      (Response response) {
        if (response.statusCode != 200) {
          print(response.reasonPhrase);
          print(response.body);
        }

        return SearchMediaItemsResponse.fromJson(jsonDecode(response.body));
      },
    );
  }

  Future<BatchCreateMediaItemsResponse> batchCreateMediaItems(
      BatchCreateMediaItemsRequest request) async {
    print(request.toJson());
    return http
        .post('https://photoslibrary.googleapis.com/v1/mediaItems:batchCreate',
            body: jsonEncode(request), headers: await _authHeaders)
        .then((Response response) {
      if (response.statusCode != 200) {
        print(response.reasonPhrase);
        print(response.body);
      }

      return BatchCreateMediaItemsResponse.fromJson(jsonDecode(response.body));
    });
  }
}
