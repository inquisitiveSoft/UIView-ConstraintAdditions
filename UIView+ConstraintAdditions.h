//  Created by Harry Jordan on 24/04/2013.
//  Copyright (c) 2013 Inquisitive Software
//  Released under the MIT license: http://opensource.org/licenses/mit-license.php


#import <UIKit/UIKit.h>


extern NSString * const SYMLLayoutHorizontalFormat;
extern NSString * const SYMLLayoutVerticalFormat;
extern NSString * const SYMLLayoutHorizontalOptions;
extern NSString * const SYMLLayoutVerticalOptions;
extern NSString * const SYMLLayoutPriority;
extern NSString * const SYMLLayoutVerticalPriority;
extern NSString * const SYMLLayoutHorizontalPriority;
extern NSString * const SYMLLayoutMetrics;
extern NSString * const SYMLLayoutViews;

extern NSString * const SYMLLayoutConstraintTop;
extern NSString * const SYMLLayoutConstraintBottom;
extern NSString * const SYMLLayoutConstraintLeft;
extern NSString * const SYMLLayoutConstraintRight;
extern NSString * const SYMLLayoutConstraintHorizontalCenter;
extern NSString * const SYMLLayoutConstraintVerticalCenter;



@interface UIView (SYMLConstraintAdditions)

- (NSDictionary *)addConstraintsWithParamaters:(NSDictionary *)parameters;
- (void)addConstraints:(NSArray *)constraints withPriority:(UILayoutPriority)priority;

- (NSDictionary *)centerView:(UIView *)viewToCenter relativeToView:(UIView *)relativeToView xAxis:(BOOL)xAxis yAxis:(BOOL)yAxis;
- (NSDictionary *)centerView:(UIView *)viewToCenter relativeToView:(UIView *)relativeToView xAxis:(BOOL)xAxis yAxis:(BOOL)yAxis priority:(UILayoutPriority)priority;

- (NSDictionary *)fillView:(UIView *)parentView;
- (NSDictionary *)fillView:(UIView *)parentView priority:(UILayoutPriority)priority;

- (NSDictionary *)matchPositionOfFirstView:(UIView *)firstVew secondView:(UIView *)secondView withPriority:(UILayoutPriority)layoutPriority;

- (void)removeAllConstraints;

@end
