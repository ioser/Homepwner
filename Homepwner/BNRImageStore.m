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
        // Register to receive low memory warnings
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self 
                               selector:@selector(clearCache:) 
                                   name:UIApplicationDidReceiveMemoryWarningNotification 
                                 object:nil];
    }
    return self;
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"Clearing image dictionary of %d instances", [dictionary count]);
    [dictionary removeAllObjects];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [dictionary setObject:image forKey:key];
    
    // Create a full path to store the image
    NSString *imagePath = [self imagePathForKey:key];
    
    // Convert the image data into a JPEG stored as an NSData instance
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // Write/persist the data to permanent storage
    [data writeToFile:imagePath atomically:YES];
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSString *result = nil;
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Since we're in iOS, the first directory is the only directory
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    result = [documentDirectory stringByAppendingPathComponent:key];
    
    return result;
}

- (UIImage *)imageForKey:(NSString *)key
{
    UIImage *result = nil;
    
    result = [dictionary objectForKey:key];
    if (result == nil) {
        // Look for the image in the file system
        NSString *imagePath = [self imagePathForKey:key];
        result = [UIImage imageWithContentsOfFile:imagePath];
        if (result != nil) {
            // Store the image in the dictionary now that we've successfully loaded it from the file system
            [dictionary setObject:result forKey:key];
        } else {
            NSLog(@"Unable to load the image %@ from the location %@", key, imagePath);
        }
    }
    
    
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (key != nil) {
        [dictionary removeObjectForKey:key];
        // Also remove it from the file system
        NSString *imagePath = [self imagePathForKey:key];
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:NULL];
    }
}

@end
