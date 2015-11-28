//
//  BJViewController.m
//  Ben Jam
//
//  Created by David Bernard on 11/12/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "BJViewController.h"
#include "BJDetailViewController.h"
#import "BJCell.h"
#import "BJItemClient.h"
#import "BJServer.h"
#import "Haneke.h"
#import <Overcoat/PromiseKit+Overcoat.h>
#import <PromiseKit/PromiseKit.h>
#import <Mantle/EXTScope.h>


@interface BJViewController ()

@end

@implementation BJViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        
    }
    return self;
}
- (PMKPromise *)loadItems {
    // Load items from server
    NSURL *itemURL = [BJServer testClientsItemAtPath: @""];
    BJItemClient * itemClient = [[BJItemClient alloc] initWithBaseURL:itemURL];
    
    NSString *itemPath;
    if (self.item == nil) {
        itemPath = @"items.json";
    }
    else {
        itemPath = [NSString stringWithFormat:@"items/%@/items.json", self.item.id];
    }
    return [itemClient GET:itemPath parameters:nil].then(^(OVCResponse *response) {
        return response.result;
    }).catch (^(NSError *error) {
        return nil;
    });
}
- (void)play {
    NSURL *audioURL_OLD = [NSURL URLWithString:[NSString stringWithFormat:@"http://benjam.herokuapp.com/%@", self.item.audioPath]];
    NSURL *audioURL = [BJServer testClientsItemAtPath:self.item.audioPath];
    assert([audioURL_OLD isEqual:audioURL]);
    //self.player = [AVPlayer playerWithURL:audioURL];
    //NSLog(@"Status %d",[self.player status]);
    //NSLog(@"Error %@",[self.player error]);
    //[self.player play];
    //NSLog(@"Status %d",[self.player status]);
    //NSLog(@"Error %@",[self.player error]);
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL
                                                              error:&error];
    self.audioPlayer.numberOfLoops = 1;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    NSLog(@"audio player %@", self.audioPlayer);
    NSLog(@"Error %@", error);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[BJCell class] forCellWithReuseIdentifier:@"Cell"];
    
    PMKPromise *loadItemsPromise =     [self loadItems];
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
    return self.items.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        // make sure we know about our cell prototype so dequeueReusableCellWithReuseIdentifier can work
        [self.collectionView registerClass:[BJCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    return self;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BJCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    BJItem *item = (BJItem *)self.items[indexPath.row];
    
    // load the image for this cell
    [cell.imageView hnk_setImageFromURL:[NSURL URLWithString:[@"http://benjam.herokuapp.com/" stringByAppendingString:item.imagePath]]];
    
    cell.label.text = [NSString stringWithFormat:@" %@", item.name];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.item = self.items[indexPath.row];
    
    PMKPromise *loadItemsPromise = [self loadItems];
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
                    
                    self.item = nil;
                    self.items = nil;
                    
                    // FIXME audio
                    [self.navigationController pushViewController:detailViewController animated:YES];
                }
            }}});
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.item = nil;
    self.items = nil;
}
@end
