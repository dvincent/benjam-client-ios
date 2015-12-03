//
//  BJViewController.m
//  Ben Jam
//
//  Created by David Bernard on 11/12/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "BJViewController.h"
#import "BJDetailViewController.h"
#import "BJCell.h"
#import "BJItemClient.h"
#import "BJServer.h"
#import "Haneke.h"
#import <Overcoat/PromiseKit+Overcoat.h>
#import <PromiseKit/PromiseKit.h>
//#import <Mantle/EXTScope.h>


@interface BJViewController ()

@end

@implementation BJViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        self.player = [[AVQueuePlayer alloc ] init];
        [self.player addObserver:self forKeyPath:@"status" options:0 context:nil];
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
    }
    return self;
}
- (PMKPromise *)loadItems:(BJItem *)item {
    NSLog(@"Load Items");
    
    // Load items from server
    NSURL *itemURL = [BJServer testClientsItemAtPath: @""];
    BJItemClient * itemClient = [[BJItemClient alloc] initWithBaseURL:itemURL];
    
    NSString *itemPath;
    if (item == nil) {
        itemPath = @"items.json";
    }
    else {
        itemPath = [NSString stringWithFormat:@"items/%@/index.json", item.id];
    }
    return [itemClient GET:itemPath parameters:nil].then(^(OVCResponse *response) {
        return response.result;
    }).catch (^(NSError *error) {
        return nil;
    });
}
- (void)playItem:(BJItem *)item {
    NSLog(@"Play item %@", item);
    NSURL *audioURL = [BJServer testClientsItemAtPath:item.audioPath];
    AVAsset *asset = [AVURLAsset assetWithURL:audioURL];
    
    if (asset .isPlayable) {
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemFailedToPlayToEndTimeNotification
                                                   object:playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemPlaybackStalledNotification
                                                   object:playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemNewErrorLogEntryNotification
                                                   object:playerItem];
        NSLog(@"Adding audio item %@", playerItem);
        [self.player insertItem:playerItem
                      afterItem:nil];
        NSLog(@"Player Status %d",[self.player status]);
    }
    else {
        NSLog(@"Not playable %@", asset);
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            
        } else if (self.player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [self.player play];
            
            
        } else if (self.player.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    NSLog(@"Player Item reached end %@", notification);
}

- (void)viewDidLoad
{
    NSLog(@"View did load %@", self);
    [super viewDidLoad];
    
    [self.collectionView registerClass:[BJCell class] forCellWithReuseIdentifier:@"Cell"];
    
    PMKPromise *loadItemsPromise =     [self loadItems:nil];
    loadItemsPromise.finally(^(void){
        self.items = loadItemsPromise.value;
        [[self collectionView] reloadData];
    });
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    NSLog(@"number of items in section %d", self.items.count);
    return self.items.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    NSLog(@"initWithCollectionViewLayout");
    if (self = [super initWithCollectionViewLayout:layout])
    {
        // make sure we know about our cell prototype so dequeueReusableCellWithReuseIdentifier can work
        [self.collectionView registerClass:[BJCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    return self;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForItemAtIndexPath %d", indexPath.row);
    BJCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    BJItem *item = (BJItem *)self.items[indexPath.row];
    
    // load the image for this cell
    [cell.imageView hnk_setImageFromURL:[BJServer testClientsItemAtPath:item.imagePath]];
    
    cell.label.text = [NSString stringWithFormat:@" %@", item.name];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didHighlightItemAtIndexPath %d", indexPath.row);
    [self playItem:self.items[indexPath.row]];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath %d", indexPath.row);
    BJItem *item = self.items[indexPath.row];
    
    PMKPromise *loadItemsPromise = [self loadItems:item];
    loadItemsPromise.finally(^(void) {
        if (! [loadItemsPromise.value isKindOfClass:[NSError class]]) {
            self.items = loadItemsPromise.value;
            if (self.items.count > 0) {
                [[self collectionView] reloadData];
            }
            else {
                BJCell *cell = (BJCell *)[collectionView cellForItemAtIndexPath:indexPath];
                if (cell.imageView.image != nil)
                {
                    // we need to load the main storyboard because this view controller was created programmatically
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    BJDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
                    // FIXME get image from item url
                    detailViewController.image = cell.imageView.image;
                    detailViewController.labelText = cell.label.text;
                    
                    [self.navigationController pushViewController:detailViewController animated:YES];
                }
            }
        } else {
            NSLog(@"Error loading items %@", loadItemsPromise.value);
        }
    });
}
- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear %@", self);
    
    PMKPromise *loadItemsPromise =     [self loadItems:self.item];
    loadItemsPromise.finally(^(void){
        self.items = loadItemsPromise.value;
        [[self collectionView] reloadData];
    });
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"PrepareForSegue from %@", sender);
}
@end
