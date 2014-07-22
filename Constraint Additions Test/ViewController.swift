//
//  ViewController.swift
//  Constraint Additions Test
//
//  Created by Harry Jordan on 20/07/2014.
//
//

import UIKit



class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		view.backgroundColor = UIColor.whiteColor()
		
		let blueView = UIView(frame: CGRect(x: 40.0, y: 40.0, width: 100.0, height: 100.0))
		blueView.setTranslatesAutoresizingMaskIntoConstraints(false)
		blueView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.6, alpha: 1.0)
		view.addSubview(blueView)
		
		var constraints = blueView.fillView(view)
		
		if let leftConstraint = constraints[NSLayoutAttribute.Leading] {
			println(leftConstraint)
			leftConstraint.constant = 40.0
		}
		
		
		let orangeView = UIView(frame: CGRect(x: 20.0, y: 20.0, width: 200.0, height: 200.0))
		orangeView.setTranslatesAutoresizingMaskIntoConstraints(false)
		orangeView.backgroundColor = UIColor.orangeColor()
		blueView.addSubview(orangeView)
		
		constraints = blueView.addConstraints(
			views: ["orange" : orangeView],
			horizontalFormat: "|-[orange]-|",
			verticalFormat:"|-[orange]-|"
		)
		
		
		let greenView = UIView(frame: CGRect(x: 20.0, y: 20.0, width: 200.0, height: 200.0))
		greenView.setTranslatesAutoresizingMaskIntoConstraints(false)
		greenView.backgroundColor = UIColor.greenColor()
		blueView.addSubview(greenView)
		
		greenView.addConstraints(views: ["greenView" : greenView], horizontalFormat:"[greenView(100)]", verticalFormat:"[greenView(100)]")
		constraints = view.centerView(greenView, relativeToView: blueView, xAxis: true, yAxis: true)
	}
}

