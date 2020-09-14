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

import 'dart:collection';
import 'dart:io';

import 'package:google_photo_app/lib/photos_library_api/photos_library_api_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sharing_codelab/photos_library_api/album.dart';
import 'package:sharing_codelab/photos_library_api/batch_create_media_items_request.dart';
import 'package:sharing_codelab/photos_library_api/batch_create_media_items_response.dart';
import 'package:sharing_codelab/photos_library_api/create_album_request.dart';
import 'package:sharing_codelab/photos_library_api/join_shared_album_request.dart';
import 'package:sharing_codelab/photos_library_api/get_album_request.dart';
import 'package:sharing_codelab/photos_library_api/join_shared_album_response.dart';
import 'package:sharing_codelab/photos_library_api/list_albums_response.dart';
import 'package:sharing_codelab/photos_library_api/list_shared_albums_response.dart';
import 'package:sharing_codelab/photos_library_api/photos_library_api_client.dart';
import 'package:sharing_codelab/photos_library_api/search_media_items_request.dart';
import 'package:sharing_codelab/photos_library_api/search_media_items_response.dart';
import 'package:sharing_codelab/photos_library_api/share_album_request.dart';
import 'package:sharing_codelab/photos_library_api/share_album_response.dart';

class PhotosLibraryApiModel extends Model {
  PhotosLibraryApiModel() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;

      if (_currentUser != null) {
        // Initialize the client with the new user credentials
        client = PhotosLibraryApiClient(_currentUser.authHeaders);
      } else {
        // Reset the client
        client = null;
      }
      // Reinitialize the albums
      updateAlbums();

      notifyListeners();
    });
  }

  final LinkedHashSet<Album> _albums = LinkedHashSet<Album>();
  bool hasAlbums = false;
  PhotosLibraryApiClient client;

  GoogleSignInAccount _currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'profile',
    'https://www.googleapis.com/auth/photoslibrary',
    'https://www.googleapis.com/auth/photoslibrary.sharing'
  ]);

  GoogleSignInAccount get user => _currentUser;

  bool isLoggedIn() {
    return _currentUser != null;
  }

  Future<bool> signIn() async {
    final GoogleSignInAccount user = await _googleSignIn.signIn();

    if (user == null) {
      // User could not be signed in
      print('User could not be signed in.');
      return false;
    }

    print('User signed in.');
    return true;
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }

  Future<void> signInSilently() async {
    final GoogleSignInAccount user = await _googleSignIn.signInSilently();
    if (_currentUser == null) {
      // User could not be signed in
      return;
    }
    print('User signed in silently.');
  }

  // 앨범을 만드는 라이브러리 API 에 대한 호출 함수
  Future<Album> createAlbum(String title) async {
    return client
        .createAlbum(CreateAlbumRequest.fromTitle(title))
        .then((Album album) {
      updateAlbums();
      return album;
    });
  }

  Future<Album> getAlbum(String id) async {
    return client
        .getAlbum(GetAlbumRequest.defaultOptions(id))
        .then((Album album) {
      return album;
    });
  }

  Future<JoinSharedAlbumResponse> joinSharedAlbum(String shareToken) {
    return client
        .joinSharedAlbum(JoinSharedAlbumRequest(shareToken))
        .then((JoinSharedAlbumResponse response) {
      updateAlbums();
      return response;
    });
  }

  Future<ShareAlbumResponse> shareAlbum(String id) async {
    return client
        .shareAlbum(ShareAlbumRequest.defaultOptions(id))
        .then((ShareAlbumResponse response) {
      updateAlbums();
      return response;
    });
  }

  Future<SearchMediaItemsResponse> searchMediaItems(String albumId) async {
    return client
        .searchMediaItems(SearchMediaItemsRequest.albumId(albumId))
        .then((SearchMediaItemsResponse response) {
      return response;
    });
  }

  Future<String> uploadMediaItem(File image) {
    return client.uploadMediaItem(image);
  }

  Future<BatchCreateMediaItemsResponse> createMediaItem(
      String uploadToken, String albumId, String description) {
    // 토큰 , AlbumId 그리고 설명을 사용하여 요청을 생성
    final BatchCreateMediaItemsRequest request =
        BatchCreateMediaItemsRequest.inAlbum(uploadToken, albumId, description);

    // media item 을 생성하려면 API 호출을 수행하세요. 응답(response)에 media item 이 포함됨
    return client
        .batchCreateMediaItems(request)
        .then((BatchCreateMediaItemsResponse response) {
      // 응답(response)를 print 하고 반환 합니다
      print(response.newMediaItemResults[0].toJson());
      return response;
    });
  }

  UnmodifiableListView<Album> get albums =>
      UnmodifiableListView<Album>(_albums ?? <Album>[]);

  void updateAlbums() async {
    // 새 앨범을 불러오기전 변수 재설정
    hasAlbums = false;

    // 모든 앨범 삭제
    _albums.clear();

    // 로그인 하지않은경우 종료
    if (!isLoggedIn()) {
      return;
    }

    // Add albums from the user's Google Photos account
    // var ownedAlbums = await _loadAlbums();
    // if (ownedAlbums != null) {
    //   _albums.addAll(ownedAlbums);
    // }

    // 사용자의 앨범과 공유앨범 불러오기
    final List<List<Album>> list =
        await Future.wait([_loadSharedAlbums(), _loadAlbums()]);

    _albums.addAll(list.expand((a) => a ?? []));

    notifyListeners();
    hasAlbums = true;
  }

  /// Load Albums into the model by retrieving the list of all albums shared
  /// with the user.
  Future<List<Album>> _loadSharedAlbums() {
    return client.listSharedAlbums().then(
      (ListSharedAlbumsResponse response) {
        return response.sharedAlbums;
      },
    );
  }

  /// Load albums into the model by retrieving the list of all albums owned
  /// by the user.
  Future<List<Album>> _loadAlbums() {
    return client.listAlbums().then(
      (ListAlbumsResponse response) {
        return response.albums;
      },
    );
  }
}
