//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Sara Duckler on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

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

- (BNRItem *)createItem
{
	BNRItem *result = [BNRItem randomItem];
	
	[allItems addObject:result];
	
	return result;
}

+ (BNRItemStore *)sharedStore
{
	static BNRItemStore *sharedStore = nil;
	if (!sharedStore) {
		sharedStore = [[super allocWithZone:nil] init];
	}
	
	return sharedStore;
}

// Override to protect our goal of making a singleton

+ (id)allocWithZone:(NSZone *)zone
{
	return [self sharedStore];
}

@end
