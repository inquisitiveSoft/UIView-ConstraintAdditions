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
		
		let createConstraintsFromFormat = {(#format: String, #options: NSLayoutFormatOptions, metrics: [String : Double]?, priority: Float) -> [NSLayoutConstraint] in
			let constraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options:options, metrics: metrics, views: views) as [NSLayoutConstraint]
			
			return constraints.map {constraint in
				constraint.priority = priority
				return constraint
			}
		}
		
		
		var constraints = [NSLayoutConstraint]()
		
		if let format = horizontalFormat {
			var p: Float = horizontalPriority ? horizontalPriority! : priority
			constraints += createConstraintsFromFormat(format, horizontalOptions, metrics, p)
		}
		
		if var format: NSString = verticalFormat {
			// Prefix V: to the given format string if necessary
			if format.compare("V:", options:NSStringCompareOptions.AnchoredSearch | NSStringCompareOptions.CaseInsensitiveSearch) != NSComparisonResult.OrderedSame {
				format = "V:" + format
			}
			
			var p: Float = verticalPriority ? verticalPriority! : priority
			constraints += createConstraintsFromFormat(format, verticalOptions, metrics, p)
		}
		
		self.addConstraints(constraints)
		
		var constraintsDictionary = Dictionary<NSLayoutAttribute, NSLayoutConstraint>()
		for constraint in constraints {
			constraintsDictionary[constraint.firstAttribute] = constraint
		}
		
		return constraintsDictionary
	}
	
	
	func addConstraints(constraints: [NSLayoutConstraint], priority: UILayoutPriority) {
		self.addConstraints(constraints.map { constraint in
			constraint.priority = priority
			return constraint
		})
	}

	
	func fillView(parentView: UIView, priority: UILayoutPriority = 1000) -> [NSLayoutAttribute : NSLayoutConstraint] {
		return parentView.addConstraints(
			views: ["view" : self],
			priority: priority,
			horizontalFormat: "|[view]|",
			verticalFormat: "|[view]|"
		)
	}

	
	func centerView(viewToCenter: UIView, relativeToView: UIView, xAxis: Bool = false, yAxis: Bool = false, priority: UILayoutPriority = 1000) -> [NSLayoutAttribute : NSLayoutConstraint] {
		let center = {(axis: NSLayoutAttribute) -> NSLayoutConstraint in
			let constraint = NSLayoutConstraint(item:viewToCenter, attribute:axis, relatedBy:NSLayoutRelation.Equal, toItem:relativeToView, attribute:axis, multiplier:1, constant:0)
			constraint.priority = priority;
			self.addConstraint(constraint)
			return constraint
		}
		
		var constraints = [NSLayoutAttribute : NSLayoutConstraint]()
		constraints[.CenterX] = center(.CenterX)
		constraints[.CenterY] = center(.CenterY)
		return constraints;
	}

}
