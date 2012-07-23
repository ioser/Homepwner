//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Richard Millet on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}
+ (BNRImageStore *) sharedStore; // defined as a singleton in the .m file

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
