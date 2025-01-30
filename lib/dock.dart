import 'package:flutter/material.dart';

class Dock<T> extends StatefulWidget {
  const Dock({super.key, this.items = const [], required this.builder});

  final List<T> items;
  final Widget Function(T, bool, bool) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T> extends State<Dock<T>> {
  late List<T> _items;
  int? _hoveredIndex;
  int? _draggedIndex;

  @override
  void initState() {
    super.initState();
    _items = widget.items.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return MouseRegion(
            onEnter: (_) {
              setState(() {
                _hoveredIndex = index;
              });
            },
            onExit: (_) {
              setState(() {
                _hoveredIndex = null;
              });
            },
            child: Draggable<int>(
              key: ValueKey(item),
              data: index,
              feedback: Transform.scale(
                scale: 1.0,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 64),
                    height: 64,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors
                          .primaries[item.hashCode % Colors.primaries.length],
                    ),
                    child: Center(
                        child: Icon(item as IconData?, color: Colors.white)),
                  ),
                ),
              ),
              childWhenDragging: const SizedBox.shrink(),
              onDragStarted: () {
                setState(() {
                  _draggedIndex = index;
                });
              },
              onDragEnd: (details) {
                setState(() {
                  _hoveredIndex = null;
                  _draggedIndex = null;
                });
              },
              child: DragTarget<int>(
                onAccept: (data) {
                  setState(() {
                    if (data != index) {
                      final draggedItem = _items.removeAt(data);
                      _items.insert(index, draggedItem);
                    }
                  });
                },
                onWillAcceptWithDetails: (data) {
                  setState(() {
                    _hoveredIndex = index;
                  });
                  return true;
                },
                onLeave: (data) {
                  setState(() {
                    _hoveredIndex = null;
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  double offset = 0.0;
                  if (_hoveredIndex != null && _hoveredIndex != index) {
                    if (_hoveredIndex! < index) {
                      offset = 35.0;
                    } else if (_hoveredIndex! > index) {
                      offset = -35.0;
                    }
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    transform: Matrix4.translationValues(offset, 0, 0),
                    child: widget.builder(
                        item, _hoveredIndex == index, _draggedIndex == index),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
