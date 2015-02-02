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

@interface BJViewController ()

@end

@implementation BJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 20;
    
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
   
    // FIXME
    // load the image for this cell
    NSString *imageToLoad = [NSString stringWithFormat:@"biscuit.jpg", indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:imageToLoad];
    cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // used tapped a collection view cell, navigate to a detail view controller showing that single photo
    BJCell *cell = (BJCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.imageView.image != nil)
    {
        // we need to load the main storyboard because this view controller was created programmatically
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        BJDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
        detailViewController.image = cell.imageView.image;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

@end
