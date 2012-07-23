//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Richard Millet on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

+ (id)alloc
{
    return [super alloc];
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (BNRImageStore *) sharedStore
{
    static BNRImageStore *sharedStore = nil; // executed just once to initalize
    if (sharedStore == nil) {
        sharedStore = [[super allocWithZone:NULL] init]; // Call our parent
    }
    return sharedStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [dictionary setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key
{
    UIImage *result = nil;
    
    result = [dictionary objectForKey:key];
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (key != nil) {
        [dictionary removeObjectForKey:key];
    }
}

@end
