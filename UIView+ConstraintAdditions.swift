//
//  UIView+Constraints.swift
//
//  Created by Harry Jordan on 10/07/2014.
//  Copyright (c) 2014 Syml. All rights reserved.
//

import UIKit


extension UIView {
	
	func addConstraints(#views: [String : UIView], priority: Float = 1000, metrics: [String : Double]? = nil,
						horizontalFormat: String? = nil, horizontalOptions: NSLayoutFormatOptions = NSLayoutFormatOptions(0), horizontalPriority: Float? = nil,
						verticalFormat: String? = nil, verticalOptions: NSLayoutFormatOptions = NSLayoutFormatOptions(0), verticalPriority: Float? = nil) -> [NSLayoutAttribute : NSLayoutConstraint] {
		
		func createConstraintsFromFormat(#format: String, #options: NSLayoutFormatOptions, metrics: [String : Double]? = nil, priority: Float = 1000) -> [NSLayoutConstraint] {
			let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options:options, metrics: metrics, views: views) as [NSLayoutConstraint]
			
			return constraints.map {constraint in
				constraint.priority = priority
				return constraint
			}
		}
		
		
		var constraints = [NSLayoutConstraint]()
		
		if let format = horizontalFormat {
			var p: Float = horizontalPriority ? horizontalPriority! : priority
			constraints += createConstraintsFromFormat(format: format, options: horizontalOptions, metrics: metrics, priority: p)
		}
		
		if var format: NSString = verticalFormat {
			// Prefix V: to the given format string if necessary
			if format.compare("V:", options:NSStringCompareOptions.AnchoredSearch | NSStringCompareOptions.CaseInsensitiveSearch) != NSComparisonResult.OrderedSame {
				format = "V:" + format
			}
			
			var p: Float = verticalPriority ? verticalPriority! : priority
			constraints += createConstraintsFromFormat(format: format, options: verticalOptions, metrics: metrics, priority:p)
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
