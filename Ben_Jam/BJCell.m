//
//  BJCell.m
//  Ben Jam
//
//  Created by David Bernard on 11/12/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "BJCell.h"
#import <Haneke/Haneke.h>

@implementation BJCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // change to our custom selected background view
        //CustomCellBackground *backgroundView = [[CustomCellBackground alloc] initWithFrame:CGRectZero];
        // create our image view so that is matches the height and width of this cell
        self.backgroundColor = [UIColor whiteColor];
        CGRect imageBounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height - 17.0);
        _imageView = [[UIImageView alloc] initWithFrame:imageBounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        
        // add a white frame around the image
        self.imageView.layer.borderWidth = 1.0;
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        // Define how the edges of the layer are rasterized for each of the four edges
        // (left, right, bottom, top) if the corresponding bit is set the edge will be antialiased
        //
        self.imageView.layer.edgeAntialiasingMask =
        kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
        [[self contentView] addSubview:self.imageView];
        
        CGRect textBounds = CGRectMake(self.bounds.origin.x,
                                       self.bounds.origin.y + (self.bounds.size.height - 17.0),
                                       self.bounds.size.width,
                                       17.0);
        
        _label = [[UILabel alloc] initWithFrame:textBounds];
     
        
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.label.contentMode = UIViewContentModeScaleAspectFill;
        self.label.clipsToBounds = YES;
        [[self contentView] addSubview:self.label];
        [[self contentView] setNeedsLayout];
        
    }


    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
}




- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)prepareForReuse
{
    [self.imageView hnk_cancelSetImage];
    self.imageView.image = nil;
}
@end
