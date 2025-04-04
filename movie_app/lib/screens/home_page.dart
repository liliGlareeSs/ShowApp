import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:movie_app/config/api_config.dart';
import 'package:movie_app/models/show_model.dart';
import 'package:movie_app/screens/add_show_page.dart';
import 'package:movie_app/screens/profile_page.dart';
import 'package:movie_app/screens/update_show_page.dart';

class ShowProvider with ChangeNotifier {
  List<Show> _movies = [];
  List<Show> _anime = [];
  List<Show> _series = [];
  bool _isLoading = true;

  List<Show> get movies => _movies;
  List<Show> get anime => _anime;
  List<Show> get series => _series;
  bool get isLoading => _isLoading;

  Future<void> fetchShows() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/shows'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Show> allShows = data.map((json) => Show.fromJson(json)).toList();

        _movies = allShows.where((show) => show.category == 'movie').toList();
        _anime = allShows.where((show) => show.category == 'anime').toList();
        _series = allShows.where((show) => show.category == 'serie').toList();
      } else {
        throw Exception('Failed to load shows: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching shows: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteShow(int id) async {
    try {
      final response = await http.delete(Uri.parse('${ApiConfig.baseUrl}/shows/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete show: ${response.statusCode}');
      }
      await fetchShows();
    } catch (e) {
      throw Exception('Error deleting show: $e');
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show App"), 
        backgroundColor: Colors.blueAccent
      ),
      drawer: _buildDrawer(context),
      body: Consumer<ShowProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return RefreshIndicator(
            onRefresh: () => provider.fetchShows(),
            child: _buildBody(context, provider),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Add Show"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  AddShowPage(onShowAdded: () {  },)),
              ).then((_) => _refreshData(context));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ShowProvider provider) {
    switch (_currentTab) {
      case 0:
        return ShowList(shows: provider.movies, onDelete: (id) => _confirmDelete(context, id));
      case 1:
        return ShowList(shows: provider.anime, onDelete: (id) => _confirmDelete(context, id));
      case 2:
        return ShowList(shows: provider.series, onDelete: (id) => _confirmDelete(context, id));
      default:
        return const Center(child: Text("Unknown Page"));
    }
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies"),
        BottomNavigationBarItem(icon: Icon(Icons.animation), label: "Anime"),
        BottomNavigationBarItem(icon: Icon(Icons.tv), label: "Series"),
      ],
      currentIndex: _currentTab,
      selectedItemColor: Colors.blueAccent,
      onTap: (index) => setState(() => _currentTab = index),
    );
  }

  void _refreshData(BuildContext context) {
    Provider.of<ShowProvider>(context, listen: false).fetchShows();
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Show"),
        content: const Text("Are you sure you want to delete this show?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Provider.of<ShowProvider>(context, listen: false).deleteShow(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Show deleted successfully")),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to delete show: ${e.toString()}")),
          );
        }
      }
    }
  }
}

class ShowList extends StatelessWidget {
  final List<Show> shows;
  final Function(int) onDelete;

  const ShowList({super.key, required this.shows, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (shows.isEmpty) {
      return const Center(child: Text("No shows available"));
    }

    return ListView.builder(
      itemCount: shows.length,
      itemBuilder: (context, index) {
        final show = shows[index];
        return Dismissible(
          key: Key(show.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Delete Show"),
                content: const Text("Are you sure you want to delete this show?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
            return confirmed ?? false;
          },
          onDismissed: (direction) => onDelete(show.id),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: show.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        ApiConfig.baseUrl + show.image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                      ),
                    )
                  : const Icon(Icons.movie, size: 50),
              title: Text(show.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(show.description),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateShowPage(show: show),
                  ),
                ).then((_) => Provider.of<ShowProvider>(context, listen: false).fetchShows()),
              ),
            ),
          ),
        );
      },
    );
  }
}