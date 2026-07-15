// Shared UI Components - Reusable widgets matching design system
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';

/// Primary Button - Filled, elevated style
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final ButtonSize size;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSizes = context.customSizes;
    final customRadius = context.customRadius;
    final customSpacing = context.customSpacing;

    final (horizontalPadding, verticalPadding, fontSize, height) =
        switch (size) {
      ButtonSize.xs => (
          customSpacing.md,
          customSpacing.xs,
          theme.textTheme.labelSmall!.fontSize!,
          customSizes.xs
        ),
      ButtonSize.sm => (
          customSpacing.md,
          customSpacing.sm,
          theme.textTheme.labelMedium!.fontSize!,
          customSizes.sm
        ),
      ButtonSize.md => (
          customSpacing.lg,
          customSpacing.md,
          theme.textTheme.labelLarge!.fontSize!,
          customSizes.md
        ),
      ButtonSize.lg => (
          customSpacing.xl,
          customSpacing.lg,
          theme.textTheme.titleMedium!.fontSize!,
          customSizes.lg
        ),
      ButtonSize.xl => (
          customSpacing.xl,
          customSpacing.xl,
          theme.textTheme.titleLarge!.fontSize!,
          customSizes.xl
        ),
    };

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height:65.9,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            const Color(0xff23446D),
          ),
          foregroundColor: WidgetStateProperty.all(
            Colors.white,
          ),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(customRadius.md),
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: fontSize * 1.2,
                height: fontSize * 1.2,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation(colorScheme.onPrimary),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: fontSize * 1.2),
                    SizedBox(width: customSpacing.sm),
                  ],
                  Text(
                    label,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: fontSize,
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    SizedBox(width: customSpacing.sm),
                    Icon(trailingIcon, size: fontSize * 1.2),
                  ],
                ],
              ),
      ),
    );
  }
}

/// Secondary Button - Outlined style
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final ButtonSize size;
  final Color? borderColor;
  final Color? textColor;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.md,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSizes = context.customSizes;
    final customRadius = context.customRadius;
    final customSpacing = context.customSpacing;
    final colorScheme = theme.colorScheme;

    final (horizontalPadding, verticalPadding, fontSize, height) =
        switch (size) {
      ButtonSize.xs => (
          customSpacing.md,
          customSpacing.xs,
          theme.textTheme.labelSmall!.fontSize!,
          customSizes.xs
        ),
      ButtonSize.sm => (
          customSpacing.md,
          customSpacing.sm,
          theme.textTheme.labelMedium!.fontSize!,
          customSizes.sm
        ),
      ButtonSize.md => (
          customSpacing.lg,
          customSpacing.md,
          theme.textTheme.labelLarge!.fontSize!,
          customSizes.md
        ),
      ButtonSize.lg => (
          customSpacing.xl,
          customSpacing.lg,
          theme.textTheme.titleMedium!.fontSize!,
          customSizes.lg
        ),
      ButtonSize.xl => (
          customSpacing.xl,
          customSpacing.xl,
          theme.textTheme.titleLarge!.fontSize!,
          customSizes.xl
        ),
    };

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 65,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          side: BorderSide(
            color: borderColor ?? colorScheme.outline,
            width: 1.5,
          ),
          foregroundColor: textColor ?? colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(customRadius.md),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: fontSize * 1.2),
              SizedBox(width: customSpacing.sm),
            ],
            Text(
              label,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? colorScheme.primary
              ),


            ),
            if (trailingIcon != null) ...[
              SizedBox(width: customSpacing.sm),
              Icon(trailingIcon, size: fontSize * 1.2),
            ],
          ],
        ),
      ),
    );
  }
}

/// Ghost Button - Text only
class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final ButtonSize size;
  final Color? textColor;

  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.md,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSizes = context.customSizes;
    final customRadius = context.customRadius;
    final customSpacing = context.customSpacing;
    final colorScheme = theme.colorScheme;

    final (horizontalPadding, verticalPadding, fontSize, height) =
        switch (size) {
      ButtonSize.xs => (
          customSpacing.md,
          customSpacing.xs,
          theme.textTheme.labelSmall!.fontSize!,
          customSizes.xs
        ),
      ButtonSize.sm => (
          customSpacing.md,
          customSpacing.sm,
          theme.textTheme.labelMedium!.fontSize!,
          customSizes.sm
        ),
      ButtonSize.md => (
          customSpacing.lg,
          customSpacing.md,
          theme.textTheme.labelLarge!.fontSize!,
          customSizes.md
        ),
      ButtonSize.lg => (
          customSpacing.xl,
          customSpacing.lg,
          theme.textTheme.titleMedium!.fontSize!,
          customSizes.lg
        ),
      ButtonSize.xl => (
          customSpacing.xl,
          customSpacing.xl,
          theme.textTheme.titleLarge!.fontSize!,
          customSizes.xl
        ),
    };

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: isFullWidth ? height : null,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          foregroundColor: textColor ?? colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(customRadius.md),
          ),
        ),
        child: Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: fontSize * 1.2),
                SizedBox(width: customSpacing.sm),
              ],
              Text(
                label,
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
              ),
              if (trailingIcon != null) ...[
                SizedBox(width: customSpacing.sm),
                Icon(trailingIcon, size: fontSize * 1.2),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Destructive Button - For dangerous actions
class DestructiveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonSize size;

  const DestructiveButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.size = ButtonSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSizes = context.customSizes;
    final customRadius = context.customRadius;
    final customSpacing = context.customSpacing;

    final (horizontalPadding, verticalPadding, fontSize, height) =
        switch (size) {
      ButtonSize.xs => (
          customSpacing.md,
          customSpacing.xs,
          theme.textTheme.labelSmall!.fontSize!,
          customSizes.xs
        ),
      ButtonSize.sm => (
          customSpacing.md,
          customSpacing.sm,
          theme.textTheme.labelMedium!.fontSize!,
          customSizes.sm
        ),
      ButtonSize.md => (
          customSpacing.lg,
          customSpacing.md,
          theme.textTheme.labelLarge!.fontSize!,
          customSizes.md
        ),
      ButtonSize.lg => (
          customSpacing.xl,
          customSpacing.lg,
          theme.textTheme.titleMedium!.fontSize!,
          customSizes.lg
        ),
      ButtonSize.xl => (
          customSpacing.xl,
          customSpacing.xl,
          theme.textTheme.titleLarge!.fontSize!,
          customSizes.xl
        ),
    };

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: theme.colorScheme.onError,
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(customRadius.md),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: fontSize * 1.2,
                height: fontSize * 1.2,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.onError),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onError),
              ),
      ),
    );
  }
}

/// Icon Button with variants
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final IconButtonVariant variant;
  final ButtonSize size;
  final Color? iconColor;
  final Color? backgroundColor;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = IconButtonVariant.standard,
    this.size = ButtonSize.md,
    this.iconColor,
    this.backgroundColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSizes = context.customSizes;
    final customRadius = context.customRadius;
    final customSpacing = context.customSpacing;
    final colorScheme = theme.colorScheme;

    final (iconSize, padding, buttonSize) = switch (size) {
      ButtonSize.xs => (18.0, customSpacing.xs, customSizes.xs),
      ButtonSize.sm => (20.0, customSpacing.sm, customSizes.sm),
      ButtonSize.md => (24.0, customSpacing.md, customSizes.md),
      ButtonSize.lg => (28.0, customSpacing.lg, customSizes.lg),
      ButtonSize.xl => (32.0, customSpacing.xl, customSizes.xl),
    };

    Widget button;

    switch (variant) {
      case IconButtonVariant.standard:
        button = IconButton(
          icon: Icon(icon,
              size: iconSize, color: iconColor ?? colorScheme.onSurfaceVariant),
          onPressed: onPressed,
          tooltip: tooltip,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.transparent,
            padding: EdgeInsets.all(padding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(customRadius.full),
            ),
          ),
        );
        break;
      case IconButtonVariant.filled:
        button = IconButton.filled(
          icon: Icon(icon,
              size: iconSize, color: iconColor ?? colorScheme.onPrimary),
          onPressed: onPressed,
          tooltip: tooltip,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? colorScheme.primary,
            padding: EdgeInsets.all(padding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(customRadius.full),
            ),
          ),
        );
        break;
      case IconButtonVariant.outlined:
        button = IconButton.outlined(
          icon: Icon(icon,
              size: iconSize, color: iconColor ?? colorScheme.primary),
          onPressed: onPressed,
          tooltip: tooltip,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.transparent,
            padding: EdgeInsets.all(padding),
            side: BorderSide(color: colorScheme.outline, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(customRadius.full),
            ),
          ),
        );
        break;
      case IconButtonVariant.tonal:
        button = IconButton.filledTonal(
          icon: Icon(icon,
              size: iconSize,
              color: iconColor ?? colorScheme.onSecondaryContainer),
          onPressed: onPressed,
          tooltip: tooltip,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? colorScheme.secondaryContainer,
            padding: EdgeInsets.all(padding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(customRadius.full),
            ),
          ),
        );
        break;
    }

    return SizedBox(width: buttonSize, height: buttonSize, child: button);
  }
}

enum ButtonSize { xs, sm, md, lg, xl }

enum IconButtonVariant { standard, filled, outlined, tonal }

/// Custom Text Field matching design system
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onPrefixTap;
  final VoidCallback? onSuffixTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onPrefixTap,
    this.onSuffixTap,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: customSpacing.xs),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          focusNode: focusNode,
          autofocus: autofocus,
          textCapitalization: textCapitalization,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            prefixIcon: prefixIcon != null
                ? InkWell(
                    onTap: onPrefixTap,
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: prefixIcon,
                    ),
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? InkWell(
                    onTap: onSuffixTap,
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.md),
                      child: suffixIcon,
                    ),
                  )
                : null,
            counterText: maxLength != null ? '' : null,
          ),
        ),
      ],
    );
  }
}

/// Product Card Widget
class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String? imageUrl;
  final double price;
  final double? compareAtPrice;
  final double rating;
  final int reviewCount;
  final bool isInStock;
  final bool isOnSale;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onWishlistToggle;
  final bool isInWishlist;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    this.imageUrl,
    required this.price,
    this.compareAtPrice,
    this.rating = 0,
    this.reviewCount = 0,
    this.isInStock = true,
    this.isOnSale = false,
    this.onTap,
    this.onAddToCart,
    this.onWishlistToggle,
    this.isInWishlist = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;
    final customShadows = context.customShadows;
    final customSizes = context.customSizes;

    final hasDiscount = compareAtPrice != null && compareAtPrice! > price;
    final discountPercent = hasDiscount
        ? ((compareAtPrice! - price) / compareAtPrice! * 100).round()
        : 0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(customRadius.lg),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: customShadows.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(customRadius.lg)),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) =>
                                _placeholderImage(context),
                          )
                        : _placeholderImage(context),
                  ),
                ),
                // Wishlist button
                Positioned(
                  top: customSpacing.sm,
                  right: customSpacing.sm,
                  child: AppIconButton(
                    icon: isInWishlist ? Icons.favorite : Icons.favorite_border,
                    variant: IconButtonVariant.filled,
                    size: ButtonSize.sm,
                    iconColor: isInWishlist
                        ? colorScheme.error
                        : colorScheme.onSurface,
                    backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
                    onPressed: onWishlistToggle,
                  ),
                ),
                // Sale badge
                if (hasDiscount)
                  Positioned(
                    top: customSpacing.sm,
                    left: customSpacing.sm,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: customSpacing.sm,
                        vertical: customSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(customRadius.full),
                      ),
                      child: Text(
                        '-$discountPercent%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onError,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                // Out of stock overlay
                if (!isInStock)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(customRadius.lg)),
                      ),
                      child: Center(
                        child: Text(
                          'Out of Stock',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(customSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: customSpacing.xs),
                  // Rating
                  if (rating > 0) ...[
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        SizedBox(width: customSpacing.xs),
                        Text(
                          rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: customSpacing.xs),
                        Text(
                          '($reviewCount)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: customSpacing.xs),
                  ],
                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                      if (hasDiscount) ...[
                        SizedBox(width: customSpacing.sm),
                        Text(
                          '\$${compareAtPrice!.toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Add to cart button
            if (isInStock)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  customSpacing.md,
                  0,
                  customSpacing.md,
                  customSpacing.md,
                ),
                child: PrimaryButton(
                  label: 'Add to Cart',
                  size: ButtonSize.sm,
                  leadingIcon: Icons.add_shopping_cart_outlined,
                  onPressed: onAddToCart,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Category Chip
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final int? count;

  const CategoryChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 16,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant),
            SizedBox(width: customSpacing.xs),
          ],
          Text(label),
          if (count != null) ...[
            SizedBox(width: customSpacing.xs),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: customSpacing.xs, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(customRadius.full),
              ),
              child: Text(
                count.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap?.call(),
      showCheckmark: false,
      padding: EdgeInsets.symmetric(
          horizontal: customSpacing.md, vertical: customSpacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(customRadius.full),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
          width: isSelected ? 0 : 1,
        ),
      ),
      backgroundColor: colorScheme.surfaceContainerHighest,
      selectedColor: colorScheme.primaryContainer,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isSelected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}

/// Loading Shimmer
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .shimmer(
          duration: 1500.ms,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        );
  }
}

/// Empty State Widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(customSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(customSpacing.xl),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            SizedBox(height: customSpacing.lg),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: customSpacing.md),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: customSpacing.xl),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error State Widget
class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(customSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(customSpacing.xl),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: colorScheme.onErrorContainer,
              ),
            ),
            SizedBox(height: customSpacing.lg),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: customSpacing.md),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: customSpacing.xl),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
