//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Sara Duckler on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Forware declare a BNRItem
@class REMItem;

@interface BNRItemStore : NSObject
{
	NSMutableArray *allItems;
}

+ (BNRItemStore *)sharedStore;

- (NSArray *)allItems;
- (REMItem *)createItem;
- (void)removeItem:(REMItem *)item;

@end
