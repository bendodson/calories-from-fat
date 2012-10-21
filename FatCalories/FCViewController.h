//
//  FCViewController.h
//  FatCalories
//
//  Created by Ben Dodson on 21/10/2012.
//  Copyright (c) 2012 Ben Dodson Apps Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAd/ADBannerView.h"

enum kFCAlertView {
    kFCAlertViewCalories100g = 100,
    kFCAlertViewCaloriesPortion
};

@interface FCViewController : UIViewController<ADBannerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
    
    float portionWeight;
    float fatWeight;
    int portionCalories;
    int fatCalories;
    
    int caloriesPer100g;
    
}

@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UITextField *portionWeightTextField;
@property (weak, nonatomic) IBOutlet UITextField *fatWeightTextField;
@property (weak, nonatomic) IBOutlet UITextField *portionCaloriesTextField;
@property (weak, nonatomic) IBOutlet UILabel *fatCaloriesLabel;

- (IBAction)beginCalculatingPortionWeight:(id)sender;
- (void)reset;

@end
