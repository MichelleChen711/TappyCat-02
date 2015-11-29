//
//  DataStore.m
//  Tappy Cat
//
//  Created by Michelle Chen on 11/28/15.
//  Copyright © 2015 Michelle Chen. All rights reserved.
//

#import "DataStore.h"

NSString * const kTopScore = @"kTopScore";

@implementation DataStore

- (id) init
{
    self = [super init];
    if (self)
    {
        _topScore = 0;
    }
    return self;
}

+ (DataStore *)sharedInstance
{
    static DataStore *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^
                  {
                      _sharedInstance = [[self alloc] init];
                  });
    
    return _sharedInstance;
}

-(void)saveData
{
    [[NSUserDefaults standardUserDefaults]
     setObject:[NSNumber numberWithInt:self.topScore] forKey:kTopScore];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)loadData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kTopScore])
    {
        self.topScore = [(NSNumber *)[[NSUserDefaults standardUserDefaults]
                                   objectForKey:kTopScore] intValue];
        
    }
    else
    {
        self.topScore = 0;
    } 
}


@end
