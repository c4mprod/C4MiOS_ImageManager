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

#import "ImageViewManager.h"
#import "ImageManager.h"


#import <QuartzCore/QuartzCore.h>

@implementation ImageViewManager
@synthesize mImageViewManagerDelegate;


- (id)initWithFrame:(CGRect)frame 
{
	self = [super initWithFrame:frame];
	if (self)
	{
        mActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        mActivity.frame = CGRectMake(self.frame.size.width/2 - mActivity.frame.size.width/2,  self.frame.size.height/2 - mActivity.frame.size.height/2,mActivity.frame.size.width, mActivity.frame.size.height );
        [self addSubview:mActivity];

	}
	return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
        mActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        mActivity.frame = CGRectMake(self.frame.size.width/2 - mActivity.frame.size.width/2,  self.frame.size.height/2 - mActivity.frame.size.height/2,mActivity.frame.size.width, mActivity.frame.size.height );

        [self addSubview:mActivity];
	}
	return self;
}

-(void)willUpdateImage
{
    [mActivity startAnimating];
    [self addSubview:mActivity];
}

- (void) didUpdateImage:(NSArray *)_array
{
    [mActivity removeFromSuperview];
	self.image = [_array objectAtIndex:1];
    if(self.image != nil)
    {
        [mImageViewManagerDelegate updateImageViewManager:self];
    }
}


- (void) dealloc
{
 //   [[ImageManager sharedImageManager] performSelectorOnMainThread:@selector(removeDelegate:) withObject:self waitUntilDone:NO];
    mImageViewManagerDelegate = nil;
    [mActivity release];
	[super dealloc];
}

@end
