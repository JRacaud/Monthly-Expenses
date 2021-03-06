import 'dart:math';
import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
    required this.openIcon,
    required this.closeIcon,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;
  final Icon openIcon;
  final Icon closeIcon;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  var _open = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();

    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.easeOutQuad);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;

      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
        width: 56,
        height: 56,
        child: Center(
          child: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            elevation: 4.0,
            child: InkWell(
              onTap: _toggle,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.closeIcon,
              ),
            ),
          ),
        ));
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
        ignoring: _open,
        child: AnimatedContainer(
          transformAlignment: Alignment.center,
          transform: Matrix4.diagonal3Values(
            _open ? 0.7 : 1.0,
            _open ? 0.7 : 1.0,
            1.0,
          ),
          duration: const Duration(milliseconds: 250),
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          child: AnimatedOpacity(
              opacity: _open ? 0.0 : 1.0,
              curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
              duration: const Duration(milliseconds: 250),
              child: FloatingActionButton(
                onPressed: _toggle,
                child: widget.openIcon,
              )),
        ));
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);

    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(_ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i]));
    }

    return children;
  }

  List<Widget> _buildButtons() {
    final children = <Widget>[];

    children.add(_buildTapToCloseFab());
    children.addAll(_buildExpandingActionButtons());
    children.add(_buildTapToOpenFab());

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: _buildButtons(),
      ),
    );
  }
}

class _ExpandingActionButton extends StatelessWidget {
  _ExpandingActionButton(
      {Key? key,
      required this.directionInDegrees,
      required this.maxDistance,
      required this.progress,
      required this.child})
      : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
            directionInDegrees * (pi / 180), progress.value * maxDistance);
        return Positioned(
            right: 4.0 + offset.dx,
            bottom: 4.0 + offset.dy,
            child: Transform.rotate(
                angle: (1.0 - progress.value) * (pi / 2), child: child!));
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
