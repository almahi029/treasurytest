import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treasury_test/v_color.dart';
import 'package:flutter_svg/flutter_svg.dart';


class VCircleIconButton extends StatelessWidget {
  final String imgPath;
  final double iconSize;
  final Color buttonColor, buttonColorDisabled, iconColor;
  final VoidCallback? onPressed;
  final bool disabled;
  final double padding;

  VCircleIconButton(
      {this.imgPath = "assets/images/logo_float.svg",
        this.iconSize = 40,
        this.padding = 10,
        this.iconColor = VColor.white,
        this.buttonColor = VColor.primary,
        this.buttonColorDisabled = VColor.primary_opacity,
        @required this.onPressed,
        this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disabled,
      child: FlatButton(
        onPressed: onPressed,
        color: buttonColor,
        materialTapTargetSize: MaterialTapTargetSize
            .shrinkWrap, //limits the touch area to the button area
        minWidth: 0, //wraps child's width
        height: 0, //wraps child's height
        disabledColor: buttonColorDisabled,
        shape: CircleBorder(),
        padding: EdgeInsets.all(padding),
        child: VSvgPicture(imgPath,
            color: iconColor, height: iconSize, width: iconSize),
      ),
    );
  }
}

class VSvgPicture extends StatelessWidget {
  final String img;
  final double? height;
  final double? width;
  final Color? color;
  final VoidCallback? onPressed;

  VSvgPicture(this.img, {this.color, this.height, this.width, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SvgPicture.asset(
        img,
        width: width,
        height: height,
        color: color,
        placeholderBuilder: (BuildContext context) {
          return Icon(
            Icons.error,
            color: VColor.primary,
          );
        },
      ),
    );
  }
}

class VText extends StatelessWidget {
  final String? title;
  final double? fontSize;
  final TextOverflow? overflow;
  final TextAlign? align;
  final bool? money;
  final TextDecoration? decoration;
  final int? maxLines;
  final Color? color;
  final bool? isBold;
  final VoidCallback? onPressed;

  VText(this.title,
      {this.fontSize,
        this.overflow,
        this.money = false,
        this.onPressed,
        this.decoration,
        this.maxLines,
        this.align,
        this.color = VColor.black,
        this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        title!,
        style: TextStyle(
          fontFamily: GoogleFonts.inter().fontFamily,
          color: color,
          fontSize: fontSize,
          fontWeight: isBold! ? FontWeight.bold : FontWeight.normal,
          decoration: decoration,
        ),
        overflow: overflow,
        textAlign: align,
        maxLines: maxLines,
      ),
    );
  }
}

class VButton extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color textColorDisabled;
  final Color buttonColor;
  final Color buttonColorDisabled;
  final VoidCallback? onPressed;
  final bool disabled;
  final double textPadding;
  final double borderRadius;

  VButton(
      this.title, {
        this.textColor = VColor.white,
        this.textColorDisabled = VColor.grey1,
        this.buttonColor = VColor.primary,
        this.buttonColorDisabled = VColor.primary_opacity,
        @required this.onPressed,
        this.disabled = false,
        this.textPadding = 24,
        this.borderRadius = 10,
      });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disabled,
      child: TextButton(
        onPressed: onPressed,
        child: VText(
          title,
          isBold: true,
          color: !disabled ? textColor : textColorDisabled,
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(textPadding)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            !disabled ? buttonColor : buttonColorDisabled,
          ),
        ),
      ),
    );
  }
}

class VExpansionTile extends StatefulWidget {
  const VExpansionTile({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
  })  : assert(initiallyExpanded != null),
        assert(
        expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
        'CrossAxisAlignment.baseline is not supported since the expanded children '
            'are aligned in a column, not a row. Try to use another constant.',
        ),
        super(key: key);

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget> children;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final Widget? trailing;

  final bool initiallyExpanded;
  final bool maintainState;
  final EdgeInsetsGeometry? tilePadding;
  final Alignment? expandedAlignment;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  final Color? iconColor;
  final Color? collapsedIconColor;
  final Color? textColor;
  final Color? collapsedTextColor;

  @override
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<VExpansionTile>
    with SingleTickerProviderStateMixin {
  static const Duration _kExpand = Duration(milliseconds: 200);

  static final Animatable<double> _easeOutTween =
  CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
  CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
  Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            iconColor: _iconColor.value,
            textColor: _headerColor.value,
            child: ListTile(
              onTap: _handleTap,
              contentPadding: widget.tilePadding,
              leading: widget.leading,
              title: widget.title,
              subtitle: widget.subtitle,
              trailing: widget.trailing ??
                  RotationTransition(
                    turns: _iconTurns,
                    child: const Icon(Icons.expand_more),
                  ),
            ),
          ),
          ClipRect(
            child: Align(
              alignment: widget.expandedAlignment ?? Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = widget.collapsedTextColor ?? theme.textTheme.subtitle1!.color
      ..end = widget.textColor ?? colorScheme.secondary;
    _iconColorTween
      ..begin = widget.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = widget.iconColor ?? colorScheme.secondary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor
      ..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      child: TickerMode(
        child: Padding(
          padding: widget.childrenPadding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment:
            widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
        enabled: !closed,
      ),
      offstage: closed,
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}


class VLoadingPage extends StatelessWidget {
  Widget _loadingPage() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(VColor.primary),
          ),
          SizedBox(
            height: 14,
          ),
          VText(
            "Please wait . . .",
            color: VColor.grey4,
            fontSize: 14,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _loadingPage();
  }
}
