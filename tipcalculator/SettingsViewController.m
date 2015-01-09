//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Peter Do on 1/6/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTip;
@property (nonatomic,weak) IBOutlet UIView *secondView;
- (IBAction)onTap:(id)sender;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
	// Get Default Tip Percentage Index
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger defaultTipIndex = [defaults integerForKey:@"defaultTipIndex"];
	
	//Save Default Tip Percentage
	self.defaultTip.selectedSegmentIndex = defaultTipIndex;

    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
	//Animate the view with a dark background
	[UIView animateWithDuration:.75 animations:^
	 {
		 self.secondView.backgroundColor = [UIColor lightGrayColor];
	 }];
}

- (IBAction)onTap:(id)sender {
	//Save selected default tip as user default
	NSInteger defaultTipIndex = self.defaultTip.selectedSegmentIndex;
	
	//NSLog(@"default Tip Index is now %d",defaultTipIndex);

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:defaultTipIndex forKey:@"defaultTipIndex"];
	[defaults synchronize];
}

@end
