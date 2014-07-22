//
//  ViewController.m
//  UIView+ConstraintAdditions
//
//  Created by Harry Jordan on 22/07/2014.
//  Released under the MIT license: http://opensource.org/licenses/mit-license.php
//

#import "ViewController.h"
#import "UIView+ConstraintAdditions.h"

@interface ViewController ()

@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
	UIView *view = self.view;
	view.backgroundColor = [UIColor whiteColor];
	
	UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(40.0, 40.0, 100.0, 100.0)];
	blueView.translatesAutoresizingMaskIntoConstraints = false;
	blueView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.6 alpha:1.0];
	[view addSubview:blueView];
	
	NSDictionary *constraints = [blueView fillView:view];
	[constraints[SYMLLayoutConstraintLeft] setConstant:40.0];
	
	UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 20.0, 200.0, 200.0)];
	orangeView.translatesAutoresizingMaskIntoConstraints = false;
	orangeView.backgroundColor = [UIColor orangeColor];
	[blueView addSubview:orangeView];
	
	constraints = [blueView addConstraintsWithParamaters:@{
		SYMLLayoutViews: NSDictionaryOfVariableBindings(orangeView),
		SYMLLayoutHorizontalFormat:	@"|-[orangeView]-|",
		SYMLLayoutVerticalFormat: @"|-[orangeView]-|",
	}];
	
	
	UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 20.0, 200.0, 200.0)];
	greenView.translatesAutoresizingMaskIntoConstraints = false;
	greenView.backgroundColor = [UIColor greenColor];
	[blueView addSubview:greenView];
	
	constraints = [blueView addConstraintsWithParamaters:@{
		SYMLLayoutViews: NSDictionaryOfVariableBindings(greenView),
		SYMLLayoutHorizontalFormat:	@"[greenView(100)]",
		SYMLLayoutVerticalFormat: @"[greenView(100)]",
	}];

	constraints = [view centerView:greenView relativeToView:blueView xAxis:TRUE yAxis:TRUE];
}


@end
