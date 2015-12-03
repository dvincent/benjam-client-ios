//
//  BJFixedGridLayout.m
//  Ben Jam
//
//  Created by David Bernard on 14/01/2015.
//  Copyright (c) 2015 Pegwing Pty Ltd. All rights reserved.
//

#import "BJFixedGridLayout.h"


@interface BJFixedGridLayout ()

@property (nonatomic, readwrite) CGSize itemSize;
@property (nonatomic, readwrite) NSMutableArray *attributesArray;

@end

@implementation BJFixedGridLayout


- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self init];
    
}
- (id)init
{
    self = [super init];
    if (self != nil)
    {
    }
    return self;
}

- (void)prepareLayout
{
    const bool log_this_method = YES;
    const CGSize size = self.collectionView.bounds.size;
    
    if (log_this_method) { NSLog(@"Collection View %@", self.collectionView); }
    // we only display one section in this layout
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];

    // Calculate area of collection view and divide by the number of items to get the area for each item
    // then the square root of the area gives the size of a suitable square.
    CGFloat itemWidth = sqrt(size.height * size.width / itemCount);
    
    long widthCount = lrint(trunc(size.width / itemWidth));
    long heightCount = lrint(trunc(size.height / itemWidth));
    
    // Add a row or a column ?
    if ( (size.width - (widthCount * itemWidth)) > (size.height - (heightCount * itemWidth))) {
        itemWidth = fmin( size.width / (widthCount+1) ,
                         size.height / (heightCount));
    }
    else
    {
        itemWidth = fmin( size.width / (widthCount) ,
                    size.height / (heightCount+1));
    }
    // Recalculate grid based on new size
    widthCount = lrint(trunc(size.width / itemWidth));
    heightCount = lrint(ceil(itemCount / (float)widthCount));
    //heightCount = lrint(trunc(size.height / itemWidth));
    
    // Caclute grid size
    CGFloat gridWidth = size.width / widthCount;
    CGFloat gridHeight = size.height / heightCount ;
    
    // Having decided on grid size, ensure item size will never be too big.
    itemWidth = MIN(itemWidth, MIN(gridWidth, gridHeight));
    
    self.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    
    if (self.attributesArray == nil)
    {
        _attributesArray = [[NSMutableArray alloc] initWithCapacity:itemCount];
    }
    if (log_this_method) {
        NSLog(@"itemSize %f %f Grid %f %f\n", self.itemSize.width, self.itemSize.height,
              gridWidth, gridHeight);
    }
    // generate the new attributes array for each photo in the stack
    for (NSInteger i = 0; i < itemCount; i++)
    {
        UICollectionViewLayoutAttributes *attributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attributes.size = self.itemSize;
        CGFloat x = (i % widthCount) * gridWidth + gridWidth/2.0;
        CGFloat y = (i / widthCount) * gridHeight + gridHeight/2.0;
        attributes.center = CGPointMake(x, y);;
        attributes.alpha = 1.0;
        attributes.zIndex = 0;
        if (log_this_method) {
            NSLog(@"itemSize %f %f Grid %f %f\n", self.itemSize.width, self.itemSize.height,
                  gridWidth, gridHeight);
            NSLog(@"Size %f %f Centre %f %f\n", attributes.size.width, attributes.size.height,
              attributes.center.x, attributes.center.y);
        }
        [self.attributesArray addObject:attributes];
    }
}

- (void)invalidateLayout
{
    [super invalidateLayout];
    _attributesArray = nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect bounds = self.collectionView.bounds;
    return ((CGRectGetWidth(newBounds) != CGRectGetWidth(bounds) ||
             (CGRectGetHeight(newBounds) != CGRectGetHeight(bounds))));
}

- (CGSize)collectionViewContentSize
{
    return self.collectionView.bounds.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.attributesArray[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}



@end
