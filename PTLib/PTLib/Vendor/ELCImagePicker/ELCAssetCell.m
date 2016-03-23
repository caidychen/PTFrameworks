//
//  AssetCell.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCConsole.h"
#import "ELCOverlayImageView.h"

@interface ELCAssetCell ()

@property (nonatomic, strong) NSArray *rowAssets;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *overlayViewArray;

@end

@implementation ELCAssetCell

//Using auto synthesizers

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.imageViewArray = mutableArray;
        
        NSMutableArray *overlayArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.overlayViewArray = overlayArray;
        
        self.alignmentLeft = YES;
	}
	return self;
}

- (void)setAssets:(NSArray *)assets
{
    self.rowAssets = assets;
	for (UIImageView *view in _imageViewArray) {
        [view removeFromSuperview];
	}
    for (ELCOverlayImageView *view in _overlayViewArray) {
        [view removeFromSuperview];
	}
    //set up a pointer here so we don't keep calling [UIImage imageNamed:] if creating overlays
    UIImage *overlayImage = nil;
    for (int i = 0; i < [_rowAssets count]; ++i) {

        ELCAsset *asset = [_rowAssets safeObjectAtIndex:i];

        if (i < [_imageViewArray count]) {
            UIImageView *imageView = [_imageViewArray safeObjectAtIndex:i];
            imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.asset.thumbnail]];
            [_imageViewArray addObject:imageView];
        }
        
        if (i < [_overlayViewArray count]) {
            ELCOverlayImageView *overlayView = [_overlayViewArray safeObjectAtIndex:i];
            overlayView.hidden = asset.selected ? NO : YES;
            overlayView.labIndex.text = [NSString stringWithFormat:@"%@", @(asset.index + 1)];
        } else {
            if (overlayImage == nil) {
                overlayImage = [UIImage imageNamed:@"overlay.png"];
            }
            ELCOverlayImageView *overlayView = [[ELCOverlayImageView alloc] initWithImage:overlayImage];
            overlayView.frame = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width-2*5)/4, ([UIScreen mainScreen].bounds.size.width-2*5)/4);
            [_overlayViewArray addObject:overlayView];
            overlayView.hidden = asset.selected ? NO : YES;
            overlayView.labIndex.text = [NSString stringWithFormat:@"%@", @(asset.index + 1)];
        }
    }
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width/4-2*4;
    CGPoint point = [tapRecognizer locationInView:self];
    int c = (int32_t)self.rowAssets.count;
    CGFloat totalWidth = c * cellWidth + (c - 1) * 4;
    CGFloat startXpoint;
    
    if (self.alignmentLeft) {
        startXpoint = 4;
    }else {
        startXpoint = (self.bounds.size.width - totalWidth) / 2;
    }
    
	CGRect frame = CGRectMake(startXpoint, 2, cellWidth, cellWidth);
	
	for (int i = 0; i < [_rowAssets count]; ++i) {
        if (CGRectContainsPoint(frame, point)) {
            ELCAsset *asset = [_rowAssets safeObjectAtIndex:i];
            asset.selected = !asset.selected;
            ELCOverlayImageView *overlayView = [_overlayViewArray safeObjectAtIndex:i];
            overlayView.frame = frame;
 
            overlayView.hidden = !asset.selected;
            if (asset.selected) {
                asset.index = [[ELCConsole mainConsole] numOfSelectedElements];
                [overlayView setIndex:asset.index+1];
                [[ELCConsole mainConsole] addIndex:asset.index];
            }
            else
            {
                long lastElement = [[ELCConsole mainConsole] numOfSelectedElements] - 1;
                [[ELCConsole mainConsole] removeIndex:lastElement];
            }
            break;
        }
        frame.origin.x = frame.origin.x + frame.size.width + 4;
    }
}

- (void)layoutSubviews
{
    CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width-2*5)/4;
//    int c = (int32_t)self.rowAssets.count;
//    CGFloat totalWidth = c * cellWidth + (c - 1) * 4;
//    CGFloat startXpoint;
//    
//    if (self.alignmentLeft) {
//        startXpoint = 4;
//    }else {
//        startXpoint = (self.bounds.size.width - totalWidth) / 2;
//    }
    
	CGRect frame = CGRectMake(2, 2, cellWidth, cellWidth);
	
	for (int i = 0; i < [_rowAssets count]; ++i) {
		UIImageView *imageView = [_imageViewArray safeObjectAtIndex:i];
		[imageView setFrame:frame];
		[self addSubview:imageView];
        
        ELCOverlayImageView *overlayView = [_overlayViewArray safeObjectAtIndex:i];
        [overlayView setFrame:frame];
        [self addSubview:overlayView];
		
		frame.origin.x = frame.origin.x + frame.size.width + 2;
	}
}


@end
