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

- (void)removeItem:(REMItem *)item
{
    [allItems removeObjectIdenticalTo:item];
}

+ (BNRItemStore *)sharedStore
{
	static BNRItemStore *sharedStore = nil; // This line is executed only once per launch of the application
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
