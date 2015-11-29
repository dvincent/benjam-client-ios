//
//  BJViewController.h
//  Ben Jam
//
//  Created by David Bernard on 11/12/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BJItem.h"


@interface BJViewController : UICollectionViewController<UICollectionViewDataSource>
@property (nonatomic,strong)BJItem *item;
@property (nonatomic,strong)NSArray *items;
@property (nonatomic,strong)AVQueuePlayer *player;
@end
