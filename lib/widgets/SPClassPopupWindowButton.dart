import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const int _windowPopupDuration = 300;
const double _kWindowCloseIntervalEnd = 2.0 / 3.0;
const Duration _kWindowDuration = Duration(milliseconds: _windowPopupDuration);

class SPClassPopupWindowButton<T> extends StatefulWidget {
  const SPClassPopupWindowButton({
    Key key,
    this.child,
    this.window,
    this.offset = Offset.zero,
    this.elevation = 2.0,
    this.duration = 300,
    this.windowChange,
    this.type = MaterialType.card,
  }) : super(key: key);

  /// 显示按钮button
  /// button which clicked will popup a window
  final Widget child;

  /// window 出现的位置。
  /// window's position in screen
  final Offset offset;

  /// 阴影
  /// shadow
  final double elevation;

  /// 需要显示的window
  /// the target window
  final Widget window;
  final ValueChanged<bool> windowChange;

  /// 按钮按钮后到显示window 出现的时间
  /// the transition duration before [window] show up
  final int duration;

  final MaterialType type;

  @override
  SPClassPopupWindowButtonState createState() {
    return SPClassPopupWindowButtonState();
  }
}

void showWindow<T>({
  @required BuildContext context,
  RelativeRect position,
  @required Widget window,
  double elevation = 8.0,
  int duration = _windowPopupDuration,
  String semanticLabel,
  ValueChanged<bool> windowChange,
  MaterialType type,
}) {
  Navigator.push(
    context,
    SPClassPopupWindowRoute<T>(
        position: position,
        child: window,
        elevation: elevation,
        duration: duration,
        windowChange:windowChange ,
        semanticLabel: semanticLabel,
        barrierLabel:
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
        type: type),
  );
}

class SPClassPopupWindowButtonState<T> extends State<SPClassPopupWindowButton> {
  void _showWindow() {
    if(widget.windowChange!=null){
      widget.windowChange(true);
    }
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(widget.offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showWindow<T>(
        context: context,
        window: widget.window,
        position: position,
        duration: widget.duration,
        elevation: widget.elevation,
        windowChange: widget.windowChange,
        type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showWindow,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class SPClassPopupWindowRoute<T> extends PopupRoute<T> {
  SPClassPopupWindowRoute({
    this.position,
    this.child,
    this.elevation,
    this.theme,
    this.barrierLabel,
    this.semanticLabel,
    this.duration,
    this.windowChange,
    this.type = MaterialType.card,
  });

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
        parent: super.createAnimation(),
        curve: Curves.linear,
        reverseCurve: const Interval(0.0, _kWindowCloseIntervalEnd));
  }

  final RelativeRect position;
  final Widget child;
  final double elevation;
  final ThemeData theme;
  final String semanticLabel;
  @override
  final String barrierLabel;
  final int duration;
  final MaterialType type;
  final ValueChanged<bool> windowChange;

  @override
  Duration get transitionDuration =>
      duration == 0 ? _kWindowDuration : Duration(milliseconds: duration);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;


  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {

    return Builder(
      builder: (BuildContext context) {
        return CustomSingleChildLayout(
          delegate: SPClassPopupWindowLayout(position),
          child: AnimatedBuilder(
              child: child,
              animation: animation,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                  opacity: animation,
                  child: Material(
                    type: type,
                    elevation: elevation,
                    child: child,
                  ),
                );
              }),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(windowChange!=null){
      windowChange(false);
    }
  }
}

class SPClassPopupWindowLayout extends SingleChildLayoutDelegate {
  SPClassPopupWindowLayout(this.position);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    double y = position.top;

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    }
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(SPClassPopupWindowLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}