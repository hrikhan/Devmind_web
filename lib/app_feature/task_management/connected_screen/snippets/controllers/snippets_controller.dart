import 'package:get/get.dart';

class SnippetsController extends GetxController {
  final snippets = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSnippets();
  }

  void loadSnippets() {
    // TODO: Load snippets from Hive
    isLoading.value = true;
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
    });
  }

  void addSnippet(String title, String code, String language) {
    snippets.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'code': code,
      'language': language,
      'createdAt': DateTime.now(),
    });
    // TODO: Save to Hive
  }

  void deleteSnippet(String id) {
    snippets.removeWhere((snippet) => snippet['id'] == id);
    // TODO: Delete from Hive
  }

  void updateSnippet(String id, String title, String code, String language) {
    final index = snippets.indexWhere((snippet) => snippet['id'] == id);
    if (index != -1) {
      snippets[index] = {
        'id': id,
        'title': title,
        'code': code,
        'language': language,
        'createdAt': snippets[index]['createdAt'],
        'updatedAt': DateTime.now(),
      };
      // TODO: Update in Hive
    }
  }
}
