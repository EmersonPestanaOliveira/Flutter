import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// === STATE ===

class CrudApiState {
  final List<dynamic> posts;
  final bool isLoading;
  final int? editingId;
  final String? editingTitle;

  CrudApiState({
    required this.posts,
    this.isLoading = false,
    this.editingId,
    this.editingTitle,
  });

  CrudApiState copyWith({
    List<dynamic>? posts,
    bool? isLoading,
    int? editingId,
    String? editingTitle,
  }) {
    return CrudApiState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      editingId: editingId,
      editingTitle: editingTitle,
    );
  }
}

// === CUBIT ===

class CrudApiCubit extends Cubit<CrudApiState> {
  CrudApiCubit() : super(CrudApiState(posts: [])) {
    fetchPosts();
  }

  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<void> fetchPosts() async {
    emit(state.copyWith(isLoading: true));
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final posts = json.decode(response.body).take(10).toList();
      emit(CrudApiState(posts: posts));
    }
  }

  Future<void> createPost(String title) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode({
        'title': title,
        'body': '',
        'userId': 1,
      }),
      headers: {'Content-type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 201) {
      final newPost = json.decode(response.body);
      final updatedPosts = List<dynamic>.from(state.posts);
      updatedPosts.insert(0, newPost);
      emit(CrudApiState(posts: updatedPosts));
    }
  }

  Future<void> updatePost(int id, String title) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      body: json.encode({
        'id': id,
        'title': title,
        'body': '',
        'userId': 1,
      }),
      headers: {'Content-type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      final updatedPost = json.decode(response.body);
      final updatedPosts = List<dynamic>.from(state.posts);
      final index = updatedPosts.indexWhere((post) => post['id'] == id);
      if (index != -1) {
        updatedPosts[index] = updatedPost;
      }
      emit(CrudApiState(posts: updatedPosts));
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final updatedPosts = List<dynamic>.from(state.posts)
        ..removeWhere((post) => post['id'] == id);
      emit(CrudApiState(posts: updatedPosts));
    }
  }

  void enterEditMode(int id, String title) {
    emit(state.copyWith(editingId: id, editingTitle: title));
  }

  void clearEditMode() {
    emit(state.copyWith(editingId: null, editingTitle: null));
  }
}

// === APP ===

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD com API + Cubit',
      home: BlocProvider(
        create: (_) => CrudApiCubit(),
        child: const CrudApiPage(),
      ),
    );
  }
}

class CrudApiPage extends StatefulWidget {
  const CrudApiPage({super.key});

  @override
  _CrudApiPageState createState() => _CrudApiPageState();
}

class _CrudApiPageState extends State<CrudApiPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addOrUpdate(CrudApiCubit cubit, CrudApiState state) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (state.editingId == null) {
      cubit.createPost(text);
    } else {
      cubit.updatePost(state.editingId!, text);
    }
    _controller.clear();
    cubit.clearEditMode();
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuild da tela!');
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD com API + Cubit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CrudApiCubit, CrudApiState>(
          builder: (context, state) {
            if (state.editingTitle != null &&
                _controller.text != state.editingTitle) {
              _controller.text = state.editingTitle!;
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length),
              );
            }

            return Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () =>
                      _addOrUpdate(context.read<CrudApiCubit>(), state),
                  child:
                      Text(state.editingId == null ? 'Adicionar' : 'Atualizar'),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: state.posts.length,
                          itemBuilder: (context, index) {
                            final post = state.posts[index];
                            return Card(
                              child: ListTile(
                                title: Text(post['title']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _controller.clear();
                                        context
                                            .read<CrudApiCubit>()
                                            .enterEditMode(
                                                post['id'], post['title']);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        context
                                            .read<CrudApiCubit>()
                                            .deletePost(post['id']);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
