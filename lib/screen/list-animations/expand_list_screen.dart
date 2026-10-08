import 'package:flutter/material.dart';
import 'expand_detail_page.dart';

typedef _Item = (IconData, String, String, Color);

class ExpandListScreen extends StatefulWidget {
  const ExpandListScreen({super.key});

  @override
  State<ExpandListScreen> createState() => _ExpandListScreenState();
}

class _ExpandListScreenState extends State<ExpandListScreen>
    with SingleTickerProviderStateMixin {
  // No longer `static const`: the list must be changeable.
  final List<_Item> _items = [
    (Icons.travel_explore, 'Explore', 'Discover new places', const Color(0xFF5C6BC0)),
    (Icons.restaurant, 'Food', 'Recipes and restaurants', const Color(0xFFEF6C00)),
    (Icons.fitness_center, 'Fitness', 'Workouts and goals', const Color(0xFF2E7D32)),
    (Icons.music_note, 'Music', 'Playlists and albums', const Color(0xFFAD1457)),
    (Icons.movie, 'Movies', 'Trending this week', const Color(0xFF6A1B9A)),
    (Icons.menu_book, 'Books', 'Your reading list', const Color(0xFF00838F)),
    (Icons.flight, 'Travel', 'Trips and bookings', const Color(0xFF1565C0)),
    (Icons.savings, 'Finance', 'Budget and savings', const Color(0xFF558B2F)),
  ];

  // Copy of the original data, used by "Restore all"
  late final List<_Item> _original = List.of(_items);

  late final AnimationController _enter;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    // Built once for the ORIGINAL count. Removing items only needs fewer of them.
    _anims = List.generate(_items.length, (i) {
      final start = i * 0.08;
      return CurvedAnimation(
        parent: _enter,
        curve: Interval(start, start + 0.4, curve: Curves.easeOutCubic),
      );
    });
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  void _open(int i) {
    final item = _items[i];
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => ExpandDetailPage(
          index: i,
          icon: item.$1,
          title: item.$2,
          subtitle: item.$3,
          color: item.$4,
        ),
        transitionsBuilder: (_, __, ___, child) => child,
      ),
    );
  }

  void _remove(int index, DismissDirection direction) {
    final removed = _items[index];
    final archived = direction == DismissDirection.startToEnd;

    setState(() => _items.removeAt(index));

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('${removed.$2} ${archived ? 'archived' : 'deleted'}'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              // Put it back at the same position
              setState(() => _items.insert(index.clamp(0, _items.length), removed));
            },
          ),
        ),
      );
  }

  void _restoreAll() {
    setState(() {
      _items
        ..clear()
        ..addAll(_original);
    });
  }

  /// The colored strip revealed behind the card while swiping.
  Widget _swipeBackground({
    required Color color,
    required IconData icon,
    required String label,
    required bool alignLeft,
  }) {
    final content = [
      Icon(icon, color:color, size: 28),
      const SizedBox(width: 8),
      Text(label,
          style:  TextStyle(
              color:color, fontWeight: FontWeight.bold)),
    ];

    return Padding(
      // Same bottom gap as the card, so the strip matches the card's height
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          // color: color,
          borderRadius: BorderRadius.circular(kCardRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: alignLeft ? content : content.reversed.toList(),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text('All cleared!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _restoreAll,
            icon: const Icon(Icons.restore),
            label: const Text('Restore all'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Animations',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 65, 3),
        automaticallyImplyLeading: false,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _items.isEmpty
            ? KeyedSubtree(key: const ValueKey('empty'), child: _emptyState())
            : ListView.builder(
                key: const ValueKey('list'),
                padding: const EdgeInsets.all(16),
                itemCount: _items.length,
                itemBuilder: (context, i) {
                  final item = _items[i];

                  return FadeTransition(
                    opacity: _anims[i],
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.35),
                        end: Offset.zero,
                      ).animate(_anims[i]),
                      child: Dismissible(
                        // Key by title (unique), NOT by index
                        key: ValueKey(item.$2),
                        dismissThresholds: const {
                          DismissDirection.startToEnd: 0.4,
                          DismissDirection.endToStart: 0.4,
                        },
                        // Swipe right
                        background: _swipeBackground(
                          color: Colors.green,
                          icon: Icons.archive_outlined,
                          label: 'Archive',
                          alignLeft: true,
                        ),
                        // Swipe left
                        secondaryBackground: _swipeBackground(
                          color:  Colors.red,
                          icon: Icons.delete_outline,
                          label: 'Delete',
                          alignLeft: false,
                        ),
                        onDismissed: (direction) => _remove(i, direction),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: GestureDetector(
                            onTap: () => _open(i),
                            child: SizedBox(
                              height: 96,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Hero(
                                      tag: 'card-bg-$i',
                                      flightShuttleBuilder: (a, b, c, d, e) =>
                                          heroShuttle(a, b, c, d, e, item.$4),
                                      child:
                                          heroBackground(item.$4, kCardRadius),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      children: [
                                        Icon(item.$1,
                                            color: Colors.white, size: 36),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.$2,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item.$3,
                                                style: const TextStyle(
                                                    color: Colors.white70),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios,
                                            color: Colors.white70, size: 18),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}