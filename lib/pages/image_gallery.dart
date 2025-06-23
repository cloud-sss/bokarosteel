import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';

class ImageGallery extends StatefulWidget {
  const ImageGallery({super.key});

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  String baseUrl = MasterModel.BaseUrl.toString();
  ScrollController _scrollController = ScrollController();

  var _imageData = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String bankId = sharedPrefModel.getUserData('bank_id');

  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _fetchImages();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _fetchImages();
      }
      if (_scrollController.offset > 300 && !_showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = true;
        });
      } else if (_scrollController.offset <= 300 && _showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = false;
        });
      }
    });
  }

  Future<void> _fetchImages() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    var map = <String, dynamic>{};
    map['bank_id'] = bankId;

    final response =
        await MasterModel.globalApiCall(1, '/get_image_gallery', map);
    if (response.statusCode == 200) {
      final fetchedUrls = json.decode(response.body);
      setState(() {
        _imageData.addAll(fetchedUrls['msg']
            .map((item) => {
                  'url': '$baseUrl/${item['IMG_URL']}',
                  'title': item['IMG_TITLE'].toString()
                })
            .toList());

        _isLoading = false;
        _hasMore = _imageData.isNotEmpty;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _imageData.clear();
      _hasMore = true;
    });
    await _fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _showImagePreview(
                        context,
                        _imageData[index]['url'].toString(),
                        _imageData[index]['title']),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: _imageData[index]['url']!,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _imageData[index]['title']!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: _imageData.length,
              ),
            ),
            SliverToBoxAdapter(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      floatingActionButton: _showScrollToTopButton
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  void _showImagePreview(BuildContext context, String imageUrl, String? title) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (title != null)
                Container(
                  color: Colors.black.withOpacity(0.7),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl.toString(),
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
