UIView+ConstraintAdditions (Swift)
==================================

My additions to help work with Auto-layout, now converted to Swift

`func addConstraints (
		#views: [String : UIView],
		priority: Float? = nil,
		metrics: [String : Double]? = nil,
	
		horizontalFormat: String? = nil,
		horizontalOptions: NSLayoutFormatOptions? = nil,
		horizontalPriority: Float? = nil,
	
		verticalFormat: String? = nil,
		verticalOptions: NSLayoutFormatOptions? = nil,
		verticalPriority: Float? = nil) -> [NSLayoutAttribute : NSLayoutConstraint]

func addConstraints(constraints: [NSLayoutConstraint], priority: UILayoutPriority)
func fillView(parentView: UIView, priority: UILayoutPriority = 1000) -> [NSLayoutAttribute : NSLayoutConstraint]
func centerView(viewToCenter: UIView, relativeToView: UIView, xAxis: Bool = false, yAxis: Bool = false, priority: UILayoutPriority = 1000) -> [NSLayoutAttribute : NSLayoutConstraint]`