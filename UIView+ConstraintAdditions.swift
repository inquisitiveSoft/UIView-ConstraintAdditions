//
//  UIView+Constraints.swift
//
//  Created by Harry Jordan on 10/07/2014.
//  Copyright (c) 2014 Syml. All rights reserved.
//

import UIKit


extension UIView {
	
	func addConstraints (
			#views: [String : UIView],
			priority: Float? = nil,
			metrics: [String : Double]? = nil,
		
			horizontalFormat: String? = nil,
			horizontalOptions: NSLayoutFormatOptions? = nil,
			horizontalPriority: Float? = nil,
		
			verticalFormat: String? = nil,
			verticalOptions: NSLayoutFormatOptions? = nil,
			verticalPriority: Float? = nil) -> [NSLayoutAttribute : NSLayoutConstraint] {
		
		if views.count == 0 {
			return Dictionary()
		}
		
		
		var constraints: [NSLayoutConstraint] = []
		
		if horizontalFormat {
			let options: NSLayoutFormatOptions = horizontalOptions ? horizontalOptions! : NSLayoutFormatOptions(0)
			let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(horizontalFormat, options:options, metrics: metrics, views: views) as [NSLayoutConstraint]
			
			if priority {
				for constraint in horizontalConstraints {
					constraint.priority = priority!
				}
			}
			
			constraints += horizontalConstraints
		}
		
		
		if var format: NSString = verticalFormat {
			// Prefix V: to the given format string if necessary
			if format.compare("V:", options:NSStringCompareOptions.AnchoredSearch | NSStringCompareOptions.CaseInsensitiveSearch) != NSComparisonResult.OrderedSame {
				format = "V:" + format
			}
			
			let options: NSLayoutFormatOptions = verticalOptions ? verticalOptions! : NSLayoutFormatOptions(0)
			let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options:options, metrics: metrics, views: views) as [NSLayoutConstraint]
			
			if priority {
				for constraint in verticalConstraints {
					constraint.priority = priority!
				}
			}
			
			constraints += verticalConstraints
		}
		
		
		self.addConstraints(constraints)

		
		var constraintsDictionary = Dictionary<NSLayoutAttribute, NSLayoutConstraint>()
		
		for constraint in constraints {
			constraintsDictionary[constraint.firstAttribute] = constraint
		}
		
		return constraintsDictionary
	}
	
	func addConstraints(constraints: [NSLayoutConstraint], priority: UILayoutPriority) {
		for constraint in constraints {
			constraint.priority = priority;
		}
		
		self.addConstraints(constraints);
	}

	
	
	func fillView(parentView: UIView, priority: UILayoutPriority = 1000) -> [NSLayoutAttribute : NSLayoutConstraint] {
		var constraints = [NSLayoutAttribute : NSLayoutConstraint]()
		
		switch(parentView) {
			case nil:
				println("\(self) is trying to add constraints to fill a nil view");
			
			case self:
				println("\(self) trying to add constraints that are self-referential");
				return Dictionary();
			
			default:
				constraints = parentView.addConstraints(
					views: ["view" : self],
					priority: priority,
					horizontalFormat: "|[view]|",
					verticalFormat: "|[view]|"
				)
		}
		
		return constraints
	}

	
	func centerView(viewToCenter: UIView, relativeToView: UIView, xAxis: Bool = false, yAxis: Bool = false, priority: UILayoutPriority = 1000) -> [NSLayoutAttribute : NSLayoutConstraint] {
		
		var constraints = [NSLayoutAttribute : NSLayoutConstraint]()
		
		if(xAxis) {
			let constraint = NSLayoutConstraint(item:viewToCenter, attribute:NSLayoutAttribute.CenterX, relatedBy:NSLayoutRelation.Equal, toItem:relativeToView, attribute:NSLayoutAttribute.CenterX, multiplier:1, constant:0)
			constraint.priority = priority;
			self.addConstraint(constraint)
			
			constraints[NSLayoutAttribute.CenterX] = constraint;
		}
		
		if(yAxis) {
			let constraint = NSLayoutConstraint(item:viewToCenter, attribute:NSLayoutAttribute.CenterY, relatedBy:NSLayoutRelation.Equal, toItem:relativeToView, attribute:NSLayoutAttribute.CenterY, multiplier:1, constant:0)
			constraint.priority = priority;
			self.addConstraint(constraint)
			
			constraints[NSLayoutAttribute.CenterY] = constraint;
		}
		
		return constraints;
	}

}
