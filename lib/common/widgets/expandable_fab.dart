import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab(
      {Key? key,
      this.initialOpen,
      required this.distance,
      required this.children})
      : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  var _open = false;

  @override
  void initState() {
    super.initState();

    _open = widget.initialOpen ?? false;
  }

  void _toggle() {
    setState(() {
      _open = !_open;
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
                child:
                    Icon(Icons.close, color: Theme.of(context).primaryColor)),
          ),
        ),
      ),
    );
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
                child: Icon(Icons.edit),
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [_buildTapToCloseFab(), _buildTapToOpenFab()],
      ),
    );
  }
}
