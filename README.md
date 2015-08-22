## Purpose
BTBadgeView is a view that replicates and extends the number badge UI element in iOS.

It supports string values instead of integers.

If you find any of these classes useful, I'd love to hear about it. If you have improvements for any of them, feel free to commit your changes. If you have any classes you would like to add to the collection, please provide them.


## ARC Support
BTBadgeView fully supports ARC.


## Supported OS
iOS 5+


## Installation
Add `pod 'BTBadgeView', :git => 'https://github.com/Tulakshana/BTBadgeView.git'` to your Podfile or drag class files into your project.

## IB_DESIGNABLE
This gives trouble if you integrate using cocoapods. However it gives trouble only when static libraries are used. Have `use_frameworks!` in your pod files to build frameworks instead of static libraries for your dependencies. If you want to use IB_DESIGNABLE integrate `pod 'BTBadgeView'`.

## Properties
	@property (nonatomic,copy) NSString *value;

The current value displayed in the badge. Updating the value will update the view's display.

	@property (nonatomic,assign) BOOL shadow;

Indicates whether the badge view draws a shadow or not.

	@property (nonatomic,assign) CGSize shadowOffset;

(Optional) The offset for the shadow.

	@property (nonatomic,strong) UIColor *shadowColor;

(Optional) The base color for the shadow.

	@property (nonatomic,assign) BOOL shine;

Indicates whether the badge view should be drawn with a shine.

	@property (nonatomic,strong) UIFont *font;

The font to be used for drawing the numbers. NOTE: Only "system fonts" should be used.

	@property (nonatomic,strong) UIColor *fillColor;

The color used for the background of the badge.

	@property (nonatomic,strong) UIColor *strokeColor;

The color to be used for drawing the stroke around the badge.

	@property (nonatomic,assign) CGFloat strokeWidth;

The width for the stroke around the badge.

	@property (nonatomic,strong) UIColor *textColor;

The color to be used for drawing the badge's numbers.

	@property (nonatomic,assign) BOOL hideWhenEmpty;

If YES, the badge will be hidden when the value is 0 or empty string.
