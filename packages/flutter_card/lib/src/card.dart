import 'package:flutter/material.dart';

class FlutterCard extends StatelessWidget {
  final Color? cardColor;
  final Color? shadowColor;
  final Color? borderColor;
  final Color? beginColorGradient;
  final Color? endColorGradient;
  final double? width;
  final double? height;
  final double? radius;
  final double? spreadRadius;
  final double? blurRadius;
  final double? rightPadding;
  final double? leftPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? rightMargin;
  final double? leftMargin;
  final double? topMargin;
  final double? bottomMargin;
  final double? symmetricHorizontalMargin;
  final double? symmetricVerticalMargin;
  final double? borderWidth;
  final Offset? offset;
  final String? assetImageUrl;
  final String? networkImageUrl;
  final bool useShadow;
  final bool useBorder;
  final bool useImage;
  final bool useImageNetwork;
  final bool useGradient;
  final AlignmentGeometry? beginAlignmentGradient;
  final AlignmentGeometry? endAlignmentGradient;
  final AlignmentGeometry? alignmentCard;
  final Widget? child;

  const FlutterCard({
    Key? key,
    this.offset,
    this.borderColor,
    this.width,
    this.cardColor,
    this.height,
    this.assetImageUrl,
    this.beginColorGradient,
    this.blurRadius,
    this.borderWidth,
    this.child,
    this.endColorGradient,
    this.networkImageUrl,
    this.radius,
    this.shadowColor,
    this.spreadRadius,
    this.leftPadding,
    this.rightPadding,
    this.bottomPadding,
    this.bottomMargin,
    this.rightMargin,
    this.leftMargin,
    this.topMargin,
    this.topPadding,
    this.symmetricHorizontalMargin,
    this.symmetricVerticalMargin,
    this.endAlignmentGradient,
    this.beginAlignmentGradient,
    this.useImageNetwork = false,
    this.useBorder = false,
    this.useGradient = false,
    this.useImage = false,
    this.useShadow = false,
    this.alignmentCard
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignmentCard,
      margin: EdgeInsets.only(
        right: rightMargin ?? 0,
        left: leftMargin ?? 0,
        bottom: bottomMargin ?? 0,
        top: topMargin ?? 0
      ),
      padding: EdgeInsets.only(
          right: rightPadding ?? 0,
          left: leftPadding ?? 0,
          bottom: bottomPadding ?? 0,
          top: topPadding ?? 0
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
        boxShadow: useShadow ? [
          BoxShadow(
            color: shadowColor ?? Colors.black12,
            spreadRadius: spreadRadius ?? 0,
            offset: offset ?? Offset.zero,
            blurRadius: blurRadius ?? 0,
          )
        ] : null,
        border: useBorder ? Border.all(
          color: borderColor ?? Colors.black54,
          width: borderWidth ?? 1,
        ) : null,
        image: useImage ? useImageNetwork
            ? DecorationImage(image: NetworkImage(networkImageUrl ?? ''))
            : DecorationImage(image: AssetImage(assetImageUrl ?? '')) : null,
        gradient: useGradient ? LinearGradient(
          colors: [
            beginColorGradient ?? Colors.white,
            endColorGradient ?? Colors.white
          ],
          begin: beginAlignmentGradient ?? Alignment.topLeft,
          end: endAlignmentGradient ?? Alignment.bottomRight,
        ) : null,
      ),
      child: child,
    );
  }
}
