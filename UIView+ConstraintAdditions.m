//  Created by Harry Jordan on 24/04/2013.
//  Copyright (c) 2013 Inquisitive Software. All rights reserved.


#import "UIView+ConstraintAdditions.h"


NSString * const SYMLLayoutHorizontalFormat = @"SYMLLayoutHorizontalFormat";
NSString * const SYMLLayoutVerticalFormat = @"SYMLLayoutVerticalFormat";

NSString * const SYMLLayoutHorizontalOptions = @"SYMLLayoutHorizontalOptions";
NSString * const SYMLLayoutVerticalOptions = @"SYMLLayoutVerticalOptions";

NSString * const SYMLLayoutPriority = @"SYMLLayoutPriority";						// A number between 0 and 1000
NSString * const SYMLLayoutHorizontalPriority = @"SYMLLayoutHorizontalPriority";	// Specific horizontal and vertical priorities will override the more general SYMLLayoutPriority
NSString * const SYMLLayoutVerticalPriority = @"SYMLLayoutVerticalPriority";

NSString * const SYMLLayoutMetrics = @"SYMLLayoutMetrics";						// A dictionary of metrics: @"metricName" : @(float)
NSString * const SYMLLayoutViews = @"SYMLLayoutViews";

NSString * const SYMLLayoutConstraintTop = @"SYMLLayoutConstraintTop";
NSString * const SYMLLayoutConstraintBottom = @"SYMLLayoutConstraintBottom";
NSString * const SYMLLayoutConstraintLeft = @"SYMLLayoutConstraintLeft";
NSString * const SYMLLayoutConstraintRight = @"SYMLLayoutConstraintRight";
//NSString * const SYMLLayoutConstraintLeading = @"SYMLLayoutConstraintLeading"
//NSString * const SYMLLayoutConstraintTrailing = @"SYMLLayoutConstraintTrailing";
NSString * const SYMLLayoutConstraintWidth = @"SYMLLayoutConstraintWidth";
NSString * const SYMLLayoutConstraintHeight = @"SYMLLayoutConstraintHeight";

NSString * const SYMLLayoutConstraintHorizontalCenter = @"SYMLLayoutConstraintHorizontalCenter";
NSString * const SYMLLayoutConstraintVerticalCenter = @"SYMLLayoutConstraintVerticalCenter";


@implementation UIView (SYMLConstraintAdditions)


- (NSDictionary *)addConstraintsWithParamaters:(NSDictionary *)parameters
{
	NSDictionary *views = parameters[SYMLLayoutViews];
	NSString *horizontalFormat = parameters[SYMLLayoutHorizontalFormat];
	NSString *verticalFormat = parameters[SYMLLayoutVerticalFormat];
	NSMutableArray *constraints = [[NSMutableArray alloc] initWithCapacity:4];
	
	if(views && (horizontalFormat || verticalFormat)) {
		NSDictionary *metrics = parameters[SYMLLayoutMetrics];
				
		if([horizontalFormat length]) {
			NSLayoutFormatOptions horizontalOptions = 0;
			NSNumber *layoutOptions = parameters[SYMLLayoutHorizontalOptions];
			if([layoutOptions respondsToSelector:@selector(integerValue)])
				horizontalOptions = [layoutOptions integerValue];
		
			NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:horizontalFormat options:horizontalOptions metrics:metrics views:views];
			
			// Apply a priority to each constraint
			NSNumber *priorityValue = [parameters valueForKey:SYMLLayoutHorizontalPriority] ? : [parameters valueForKey:SYMLLayoutPriority];
			
			if(priorityValue && [priorityValue respondsToSelector:@selector(integerValue)]) {
				for(NSLayoutConstraint *constraint in horizontalConstraints)
					constraint.priority = [priorityValue integerValue];
			}
			
			[constraints addObjectsFromArray:horizontalConstraints];
		}
		
		if([verticalFormat length]) {
			NSLayoutFormatOptions verticalOptions = 0;
			NSNumber *layoutOptions = parameters[SYMLLayoutVerticalOptions];
			if([layoutOptions respondsToSelector:@selector(integerValue)])
				verticalOptions = [layoutOptions integerValue];
			
			// Add the V: if none exists already
			if([verticalFormat length] <= 2 || ![[verticalFormat substringToIndex:2] isEqualToString:@"V:"])
				verticalFormat = [@"V:" stringByAppendingString:verticalFormat];
			
			NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:verticalFormat options:verticalOptions metrics:metrics views:views];
			
			// Apply a priority to each constraint
			NSNumber *priorityValue = [parameters valueForKey:SYMLLayoutVerticalPriority] ? : [parameters valueForKey:SYMLLayoutPriority];
			
			if(priorityValue && [priorityValue respondsToSelector:@selector(integerValue)]) {
				NSInteger priority = [priorityValue integerValue];
				
				for(NSLayoutConstraint *constraint in verticalConstraints)
					constraint.priority = priority;
			}
			
			[constraints addObjectsFromArray:verticalConstraints];
		}
	}
	

	[self addConstraints:constraints];
	
	NSMutableDictionary *constraintsDictionary = [[NSMutableDictionary alloc] initWithCapacity:4];

	for(NSLayoutConstraint *constraint in constraints) {
		NSString *key = SYMLLayoutKeyForAttribute(constraint.firstAttribute);
		
		if(key) {
			constraintsDictionary[key] = constraint;
		}
	}
	
	return constraintsDictionary;
}


- (void)addConstraints:(NSArray *)constraints withPriority:(UILayoutPriority)priority
{
	for(NSLayoutConstraint *constraint in constraints)
		constraint.priority = priority;
	
	[self addConstraints:constraints];
}



- (NSDictionary *)centerView:(UIView *)viewToCenter relativeToView:(UIView *)relativeToView xAxis:(BOOL)xAxis yAxis:(BOOL)yAxis
{
	return [self centerView:(UIView *)viewToCenter relativeToView:(UIView *)relativeToView xAxis:(BOOL)xAxis yAxis:(BOOL)yAxis priority:UILayoutPriorityRequired];
}


- (NSDictionary *)centerView:(UIView *)viewToCenter relativeToView:(UIView *)relativeToView xAxis:(BOOL)xAxis yAxis:(BOOL)yAxis priority:(UILayoutPriority)priority
{
	if(!viewToCenter || !relativeToView) {
		NSLog(@"centerView:relativeToView:xAxis:yAxis: requires both a viewToCenter (%@) and relativeToView (%@)", viewToCenter, relativeToView);
		return nil;
	}
	
	
	NSMutableDictionary *constraints = [[NSMutableDictionary alloc] initWithCapacity:2];
	
	if(xAxis) {
		NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:viewToCenter attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:relativeToView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
		constraint.priority = priority;
		[self addConstraint:constraint];
		
		constraints[SYMLLayoutConstraintHorizontalCenter] = constraint;
	}
	
	if(yAxis) {
		NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:viewToCenter attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:relativeToView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
		constraint.priority = priority;
		[self addConstraint:constraint];
		
		constraints[SYMLLayoutConstraintVerticalCenter] = constraint;
	}
	
	return constraints;
}


- (NSDictionary *)fillView:(UIView *)parentView
{
	return [self fillView:parentView priority:UILayoutPriorityRequired];
}


- (NSDictionary *)fillView:(UIView *)parentView priority:(UILayoutPriority)priority
{
	NSDictionary *constraints = nil;
	
	if(!parentView) {
		NSLog(@"%@ is trying to add constraints to fill a nil view", self);
	} else if(parentView == self) {
		NSLog(@"%@ trying to add constraints that are self-referential", self);
	} else {
		constraints = [parentView addConstraintsWithParamaters:@{
			SYMLLayoutHorizontalFormat : @"|[self]|",
			SYMLLayoutVerticalFormat : @"|[self]|",
			SYMLLayoutPriority : @(priority),
			SYMLLayoutViews : NSDictionaryOfVariableBindings(self)
		}];
	}
	
	return constraints;
}


- (NSDictionary *)matchPositionOfFirstView:(UIView *)firstVew secondView:(UIView *)secondView withPriority:(UILayoutPriority)layoutPriority
{
	NSDictionary *constraints = @{
		SYMLLayoutConstraintTop		: [NSLayoutConstraint constraintWithItem:firstVew attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
		SYMLLayoutConstraintBottom	: [NSLayoutConstraint constraintWithItem:firstVew attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0],
		SYMLLayoutConstraintLeft	: [NSLayoutConstraint constraintWithItem:firstVew attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0],
		SYMLLayoutConstraintRight	: [NSLayoutConstraint constraintWithItem:firstVew attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]
	};
	
	[self addConstraints:[constraints allValues] withPriority:layoutPriority];
	
	return constraints;
}


- (void)removeAllConstraints
{
	NSArray *currentConstraints = [self constraints];
	
	if([currentConstraints count] > 0)
		[self removeConstraints:currentConstraints];
}



NSString *SYMLLayoutKeyForAttribute(NSLayoutAttribute layoutAttribute) {
	NSString *key = nil;
	
	switch(layoutAttribute) {
		case NSLayoutAttributeTop:
			key = SYMLLayoutConstraintTop;
			break;
		
		case NSLayoutAttributeBottom:
			key = SYMLLayoutConstraintBottom;
			break;
		
		case NSLayoutAttributeLeft:
			key = SYMLLayoutConstraintLeft;
			break;
		
		case NSLayoutAttributeRight:
			key = SYMLLayoutConstraintRight;
			break;
		
		case NSLayoutAttributeLeading:
			key = SYMLLayoutConstraintLeft;
			break;
		
		case NSLayoutAttributeTrailing:
			key = SYMLLayoutConstraintRight;
			break;
		
		default:
			break;
	}
	
	return key;
}



@end
