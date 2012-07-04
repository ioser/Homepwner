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
