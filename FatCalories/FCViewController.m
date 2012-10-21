//
//  FCViewController.m
//  FatCalories
//
//  Created by Ben Dodson on 21/10/2012.
//  Copyright (c) 2012 Ben Dodson Apps Ltd. All rights reserved.
//

#import "FCViewController.h"
#import "FCCalorieCalculator.h"

@implementation FCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Calories From Fat";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    UIView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 235)];
    [bg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient-bg"]]];
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    _fatCaloriesLabel.text = @"";
        
    _portionWeightTextField.delegate = self;
    _fatWeightTextField.delegate = self;
    _portionCaloriesTextField.delegate = self;
    
    [_portionWeightTextField becomeFirstResponder];
    
    _bannerView.hidden = YES;
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height > 480) || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _bannerView.delegate = self;
    }
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleBordered target:self action:@selector(reset)]];
}

- (void)updateFatCaloriesLabel
{
    if (!portionWeight || !fatWeight || !portionCalories) {
        fatCalories = 0;
        _fatCaloriesLabel.text = @"";
        return;
    }

    fatCalories = [FCCalorieCalculator calculateFatCaloriesFromCalories:portionCalories totalWeight:portionWeight andFatWeight:fatWeight];
    _fatCaloriesLabel.text = [NSString stringWithFormat:@"%d kcal of fat per %.1fg serving", fatCalories, portionWeight];
}

- (void)reset
{
    _fatCaloriesLabel.text = @"";
    
    _portionWeightTextField.text = nil;
    _fatWeightTextField.text = nil;
    _portionCaloriesTextField.text = nil;
    
    portionWeight = 0.0;
    fatWeight = 0.0;
    portionCalories = 0;
    fatCalories = 0;
    
    [_portionWeightTextField becomeFirstResponder];
}

- (IBAction)beginCalculatingPortionWeight:(id)sender
{
    [self displayCaloriesPer100gPrompt];
}

- (void)displayCaloriesPer100gPrompt
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Portion Weight" message:@"How many calories (kcal) are there in 100g of the food?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Next", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    alert.tag = kFCAlertViewCalories100g;
    [alert show];
}

- (void)displayCaloriesPerPortionPrompt
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Portion Weight" message:@"How many calories (kcal) are there in a single portion of the food?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Calculate", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    alert.tag = kFCAlertViewCaloriesPortion;
    [alert show];
}


#pragma mark - UIAlertView Callbacks

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_portionWeightTextField becomeFirstResponder];
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    switch (alertView.tag) {
        case kFCAlertViewCalories100g:
            caloriesPer100g = [alertView textFieldAtIndex:0].text.intValue;
            if (caloriesPer100g == 0) {
                [self displayCaloriesPer100gPrompt];
            } else {
                [self displayCaloriesPerPortionPrompt];
            }
            break;
        case kFCAlertViewCaloriesPortion:
            portionCalories = [alertView textFieldAtIndex:0].text.intValue;
            if (portionCalories == 0) {
                [self displayCaloriesPerPortionPrompt];
            } else {
                portionWeight = [FCCalorieCalculator calculatePortionWeightFromCaloriesPer100g:caloriesPer100g andCaloriesPerPortion:portionCalories];
                _portionWeightTextField.text = [NSString stringWithFormat:@"%.2f", portionWeight];
            }
            
            _portionCaloriesTextField.text = [NSString stringWithFormat:@"%d", portionCalories];
            [self updateFatCaloriesLabel];
            break;
    }
}

#pragma mark - UITextField Callbacks

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateLocalValue:value withTextField:textField];
    [self updateFatCaloriesLabel];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateLocalValue:textField.text withTextField:textField];
    [self updateFatCaloriesLabel];
}

- (void)updateLocalValue:(NSString *)value withTextField:(UITextField *)textField
{
    if ([textField isEqual:_portionWeightTextField]) {
        portionWeight = value.floatValue;
    }
    if ([textField isEqual:_fatWeightTextField]) {
        fatWeight = value.floatValue;
    }
    if ([textField isEqual:_portionCaloriesTextField]) {
        portionCalories = value.intValue;
    }
}

#pragma mark - iAd Callbacks

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    _bannerView.hidden = NO;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    _bannerView.hidden = YES;
}



@end
