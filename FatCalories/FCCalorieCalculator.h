//
//  FCCalorieCalculator.h
//  FatCalories
//
//  Created by Ben Dodson on 21/10/2012.
//  Copyright (c) 2012 Ben Dodson Apps Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCCalorieCalculator : NSObject {
    
}

+ (float)calculatePortionWeightFromCaloriesPer100g:(int)caloriesPer100g andCaloriesPerPortion:(int)caloriesPerPortion;
+ (float)calculateFatCaloriesFromCalories:(int)calories totalWeight:(float)totalWeight andFatWeight:(float)fatWeight;

@end
