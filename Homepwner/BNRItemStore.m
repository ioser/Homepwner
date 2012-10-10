//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Richard Millet on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRItemStore.h"
#import "REMItem.h"
#import "BNRImageStore.h"

#define ITEMS_ARCHIVE_NAME @"items.archive"

@implementation BNRItemStore

- (id)init
{
	self = [super init];
	if (self) {
        NSString *fromPath = [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:fromPath];
        if (allItems == nil) {
            allItems = [[NSMutableArray alloc] init];
        }
	}
	
	return self;
}

- (NSArray *)allItems
{
	return allItems;
}

- (REMItem *)createItem
{
//	REMItem *result = [REMItem randomItem];
	REMItem *result = [[REMItem alloc] init];
	
	[allItems addObject:result];
	
	return result;
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    // An optimization check first
    if (from != to) {
        REMItem *tmp = [allItems objectAtIndex:from];
        [allItems removeObjectAtIndex:from];
        [allItems insertObject:tmp atIndex:to];
    }
}

- (void)removeItem:(REMItem *)item
{
    // If there is an image, we need to delete/remove it from the file system
    NSString *imageKey = [item imageKey];
    if (imageKey) {
        [[BNRImageStore sharedStore] deleteImageForKey:imageKey];
    }
    [allItems removeObjectIdenticalTo:item];
}

// Create a file system path to the place we'll archive/persist the items
- (NSString *)itemArchivePath
{
    NSString *result = nil;
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Since we're in iOS, the first directory is the only directory
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    result = [documentDirectory stringByAppendingPathComponent:ITEMS_ARCHIVE_NAME];
    
    return result;
}

// Save/perist the list of items
- (BOOL)saveChanges
{
    BOOL result = false;

    NSString *toPath = [self itemArchivePath];
    result = [NSKeyedArchiver archiveRootObject:allItems toFile:toPath];
    
    return result;
}

+ (int)count
{
    return [[[self sharedStore] allItems] count];
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
