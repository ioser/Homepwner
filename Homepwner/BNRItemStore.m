//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Richard Millet on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRItemStore.h"
#import "REMItem.h"

@implementation BNRItemStore

- (id)init
{
	self = [super init];
	if (self) {
		allItems = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (NSArray *)allItems
{
	return allItems;
}

- (REMItem *)createItem
{
	REMItem *result = [REMItem randomItem];
	
	[allItems addObject:result];
	
	return result;
}

+ (BNRItemStore *)sharedStore
{
	static BNRItemStore *sharedStore = nil; // This line is executed only once per launch of the application
	if (!sharedStore) {
		sharedStore = [[super allocWithZone:nil] init];
	}
	
	return sharedStore;
}

- (NSInteger)numOfItemsWithValueGreaterThan:(NSInteger)max
{
    int result = 0;
    
    int total = [allItems count];
    for (int i = 0; i < total; i++) {
        REMItem *tmp = [allItems objectAtIndex:i];
        if (tmp.valueInDollars > max) {
            result++;
        }
    }
    
    return result;
}

- (REMItem *)itemWithValueGreaterThan:(NSInteger)max atIndex:(int)index
{
    REMItem * result = nil;
    int hits = -1;
    
    int total = [allItems count];
    for (int i = 0; i < total && hits != index; i++) {
        REMItem *tmp = [allItems objectAtIndex:i];
        if (tmp.valueInDollars > max) {
            hits++;
        }
        if (hits == index) {
            result = tmp;
        }
    }
        
    return result;
}

- (REMItem *)itemWithValueLessThanOrEqual:(NSInteger)max atIndex:(int)index
{
    REMItem * result = nil;
    int hits = -1;
    
    int total = [allItems count];
    for (int i = 0; i < total && hits != index; i++) {
        REMItem *tmp = [allItems objectAtIndex:i];
        if (tmp.valueInDollars <= max) {
            hits++;
        }
        if (hits == index) {
            result = tmp;
        }
    }
    
    return result;
}


// Override to protect our goal of making a singleton

+ (id)allocWithZone:(NSZone *)zone
{
	return [self sharedStore];
}

@end
