/*******************************************************************************
 * This file is part of the C4MiOS_ImageManager project.
 * 
 * Copyright (c) 2012 C4M PROD.
 * 
 * C4MiOS_ImageManager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * C4MiOS_ImageManager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with C4MiOS_ImageManager. If not, see <http://www.gnu.org/licenses/lgpl.html>.
 * 
 * Contributors:
 * C4M PROD - initial API and implementation
 ******************************************************************************/

#import "ImageViewManagerRound.h"

@implementation ImageViewManagerRound


static inline UIImage* MTDContextCreateRoundedMask( CGRect rect, CGFloat radius_tl, CGFloat radius_tr, CGFloat radius_bl, CGFloat radius_br ) {  
    
    CGContextRef context;
    CGColorSpaceRef colorSpace;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a bitmap graphics context the size of the image
    context = CGBitmapContextCreate( NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast );
    
    // free the rgb colorspace
    CGColorSpaceRelease(colorSpace);    
    
    if ( context == NULL ) {
        return NULL;
    }
    
    // cerate mask
    
    CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
    CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
    
    CGContextBeginPath( context );
    CGContextSetGrayFillColor( context, 1.0, 0.0 );
    CGContextAddRect( context, rect );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
    
    CGContextSetGrayFillColor( context, 1.0, 1.0 );
    CGContextBeginPath( context );
    CGContextMoveToPoint( context, minx, midy );
    CGContextAddArcToPoint( context, minx, miny, midx, miny, radius_bl );
    CGContextAddArcToPoint( context, maxx, miny, maxx, midy, radius_br );
    CGContextAddArcToPoint( context, maxx, maxy, midx, maxy, radius_tr );
    CGContextAddArcToPoint( context, minx, maxy, minx, midy, radius_tl );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef bitmapContext = CGBitmapContextCreateImage( context );
    CGContextRelease( context );
    
    // convert the finished resized image to a UIImage 
    UIImage *theImage = [UIImage imageWithCGImage:bitmapContext];
    // image is retained by the property setting above, so we can 
    // release the original
    CGImageRelease(bitmapContext);
    
    // return the image
    return theImage;
}  


- (id)initWithFrame:(CGRect)frame 
{
	self = [super initWithFrame:frame];
	if (self)
	{
        /*mMaskRound = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"masque_small.png"]];
        mMaskRound.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height );
        mMaskRound.contentStretch = CGRectMake(0.5, 0.5, 0.1, 0.1);
        [self addSubview:mMaskRound];
        mMaskRound.hidden = true;*/
        
        
        
        /*
        self.layer.shouldRasterize = false;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = true;*/
        
        
        UIImage *mask = MTDContextCreateRoundedMask( self.bounds, 8.0, 8.0, 8.0, 8.0 );
        CALayer *layerMask = [CALayer layer];
        layerMask.frame = self.bounds;       
        layerMask.contents = (id)mask.CGImage;       
        self.layer.mask = layerMask;  
	}
	return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
        /*mMaskRound = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"masque_small.png"]];
        mMaskRound.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height );
        mMaskRound.contentStretch = CGRectMake(0.5, 0.5, 0.1, 0.1);
        [self addSubview:mMaskRound];
        mMaskRound.hidden = true;*/
        
        
        /*
        self.layer.shouldRasterize = false;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = true;*/
        
        
        UIImage *mask = MTDContextCreateRoundedMask( self.bounds, 8.0, 8.0, 8.0, 8.0 );
        CALayer *layerMask = [CALayer layer];
        layerMask.frame = self.bounds;       
        layerMask.contents = (id)mask.CGImage;       
        self.layer.mask = layerMask;     
	}
	return self;
}



- (void) didUpdateImage:(NSArray *)_array
{
    [super didUpdateImage:_array];
    if(self.image != nil)
    {
        //mMaskRound.hidden = false;
    }
}












@end
