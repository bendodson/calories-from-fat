//
//  FCCalorieCalculator.m
//  FatCalories
//
//  Created by Ben Dodson on 21/10/2012.
//  Copyright (c) 2012 Ben Dodson Apps Ltd. All rights reserved.
//

#import "FCCalorieCalculator.h"

@implementation FCCalorieCalculator

+ (float)calculatePortionWeightFromCaloriesPer100g:(int)caloriesPer100g andCaloriesPerPortion:(int)caloriesPerPortion
{
    return ((float)caloriesPerPortion/(float)caloriesPer100g)*100;
}

+ (float)calculateFatCaloriesFromCalories:(int)calories totalWeight:(float)totalWeight andFatWeight:(float)fatWeight
{
    return round((fatWeight/totalWeight)*calories);
}

@end
