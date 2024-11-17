import 'package:flutter/material.dart';
import 'package:flutter_app/components/Header.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> items = List.generate(20, (index) {
    return {
      'title': 'Item $index',
      'image': 'lib/assets/images/carrot.png',
    };
  });

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    List<Map<String, String>> newItems = List.generate(10, (index) {
      return {
        'title': 'New Item ${items.length + index}',
        'image': 'lib/assets/images/carrot.png',
      };
    });

    setState(() {
      items.addAll(newItems);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SafeArea(
            child: Header(),
          ),
          const SizedBox(height: 8), // 헤더와 첫 번째 아이템 간 간격
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(), // 스크롤 속도 및 부드러운 스크롤
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 ? 0.0 : 16.0, // item 0의 위 패딩 제거
                        bottom: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0), // 둥근 모서리 추가
                            child: Image.asset(
                              items[index]['image']!,
                              width: 100, // 정사각형 크기
                              height: 100, // 정사각형 크기
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16), // 이미지와 텍스트 간 간격
                          Expanded(
                            child: Text(
                              items[index]['title']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 193, 193, 193),
                      thickness: 0.3,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
