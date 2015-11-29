//
//  DataStore.h
//  Tappy Cat
//
//  Created by Michelle Chen on 11/28/15.
//  Copyright © 2015 Michelle Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject

+ (DataStore *)sharedInstance;

@property (assign) int topScore;

-(void) saveData;
-(void) loadData;

@end
