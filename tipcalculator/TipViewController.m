//
//  TipViewController.m
//  tipcalculator
//
//  Created by Peter Do on 1/6/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (nonatomic,weak) IBOutlet UIView *firstView;
@property (nonatomic,weak) IBOutlet UIView *secondView;


- (IBAction)onTap:(id)sender;
- (void)updateValues;
- (void)onSettingsButton;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
		self.title = @"Tip Calculator";
        // Custom initialization
    }
    return self;
	
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self updateValues];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
	
	// Optionally initialize the property to a desired starting value
	self.firstView.alpha = 0;
	self.secondView.alpha = 1;
	[UIView animateWithDuration:1 animations:^{
		// This causes first view to fade in and second view to fade out
		self.firstView.alpha = 1;
		self.secondView.alpha = 0;
	}];

	// Get Default Tip Percentage and the Last Time View was loaded
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger defaultTipIndex = [defaults integerForKey:@"defaultTipIndex"];
	NSDate *timePrevious = [defaults objectForKey:@"timePrevious"];
	
	//Set Default Tip Percentage
	self.tipControl.selectedSegmentIndex = defaultTipIndex;
	
	//Calculate how many seconds have passed since the last time view was loaded
	NSDate *timeNow = [NSDate date];
	double seconds = [timeNow timeIntervalSinceDate:timePrevious];
	printf("\n %0.0f seconds since last view \n", seconds);
	
	//Reload last bill amount if view was loaded within 600 seconds
	if (seconds<600) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSString *billText = [defaults stringForKey:@"billText"];
		self.billTextField.text = billText;
		printf("Bill amount reloaded.\n");
	// otherwise, clear bill amount
	}else{
		self.billTextField.text = nil;
		printf("Bill amount cleared.\n");
	}

	[self updateValues];
}

- (void)viewDidDisappear:(BOOL)animated {

	//timePrevious = last time view was exited
	NSDate *timePrevious = [NSDate date];
	
	//Save the bill amount from last time view was exited as default
	NSString *billText = self.billTextField.text;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:timePrevious forKey:@"timePrevious"];
	[defaults setObject:billText forKey:@"billText"];
	[defaults synchronize];
}

- (IBAction)onTap:(id)sender {
	[self.view endEditing:YES];
	[self updateValues];
}

- (void)updateValues{
	
	//Calculate tip and total Amount
	float billAmount = [self.billTextField.text floatValue];
	
	NSArray *tipValues = @[@(0.1), @(0.15), @(0.2)];
	
	float tipAmount = billAmount * [tipValues [self.tipControl.selectedSegmentIndex] floatValue];
	
	float totalAmount = tipAmount + billAmount;
	
	//Format labels local currency symbols and with comma separator
	NSString *comma = @",";
	NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
	[currencyFormatter setLocale:[NSLocale currentLocale]];
	[currencyFormatter setMaximumFractionDigits:2];
	[currencyFormatter setMinimumFractionDigits:2];
	[currencyFormatter setAlwaysShowsDecimalSeparator:YES];
	[currencyFormatter setGroupingSeparator:comma];
	[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	
	NSNumber *tipNumber = [NSNumber numberWithFloat:tipAmount];
	NSString *tipString = [currencyFormatter stringFromNumber:tipNumber];
	
	NSNumber *totalNumber = [NSNumber numberWithFloat:totalAmount];
	NSString *totalString = [currencyFormatter stringFromNumber:totalNumber];
	
	self.tipLabel.text = tipString;
	self.totalLabel.text = totalString;
}

- (void)onSettingsButton {
   [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}
@end
