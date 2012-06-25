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
 
#import "ImageManager.h"

/*
@implementation NSMutableArray (WeakReferences)

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity
{
	CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
	// We create a weak reference array
	return (id)(CFArrayCreateMutable(0, capacity, &callbacks));
}

+ (id)mutableArrayUsingWeakReferences
{
	return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}


@end
*/

@implementation ImageManager
@synthesize mDicoImage;
@synthesize mDelegateDictionary;
@synthesize mArrayKey;

static ImageManager *	sharedImageManagerInstance = nil;

+ (ImageManager *)sharedImageManager
{
	if (sharedImageManagerInstance == nil)
	{
		sharedImageManagerInstance = [[ImageManager alloc] init];
	}
	return sharedImageManagerInstance;
}

- (id) init
{
	self = [super init];
	
	if (self)
	{
		self.mDicoImage				= [NSMutableDictionary dictionary];
        self.mArrayKey              = [NSMutableArray array];
        self.mDelegateDictionary	= [NSMutableDictionary dictionary];
	}
	return self;
}

- (void) dealloc
{
	[mDicoImage release];
    [mArrayKey release];
	[mDelegateDictionary release];
	[super dealloc];
}


- (NSString *) applicationImagesDirectory
{
	NSString *basePath = NSTemporaryDirectory();
	return basePath;
}





- (UIImage *) getImageNamed:(NSString *)urlImage withDelegate:(NSObject <ImageManagerDelegate> *)delegate
{
    [self removeDelegate:delegate];
	if(urlImage != nil)
	{
		// Image already in memory.
		if ([mDicoImage valueForKey:urlImage] != nil)
		{
			if(delegate != nil)
			{
                [delegate performSelectorOnMainThread: @selector(didUpdateImage:) withObject:[NSArray arrayWithObjects:urlImage,[mDicoImage valueForKey:urlImage],nil] waitUntilDone:YES];
			}
			return [mDicoImage valueForKey:urlImage];
		}
		// Image have to be downloaded.
		else
		{
			NSString * local_img_path = [[self applicationImagesDirectory] stringByAppendingPathComponent:[[urlImage stringByReplacingOccurrencesOfString:@":" withString:@"!"] stringByReplacingOccurrencesOfString:@"/" withString:@"!"]];
			if ([[NSFileManager defaultManager] fileExistsAtPath:local_img_path]) 
			{
				UIImage * img = [UIImage imageWithContentsOfFile:local_img_path];
                [self performSelectorOnMainThread: @selector(addImageViewInArray:) withObject:[NSMutableArray arrayWithObjects:img,urlImage, nil] waitUntilDone:YES];	
                
                [delegate performSelectorOnMainThread: @selector(didUpdateImage:) withObject:[NSArray arrayWithObjects:urlImage,img,nil] waitUntilDone:NO];
				return [mDicoImage valueForKey:urlImage];
			} 
			else 
			{ 
				// If there already exist a entry in the ditionary for this image.
				if([mDelegateDictionary objectForKey:urlImage] != nil)
				{
					if (delegate)
					{
						[[mDelegateDictionary objectForKey:urlImage] addObject:delegate];
					}
					
				}
				// If this is the first ask for this image.
				else 
				{
					// Create the array.
					 //[NSMutableArray mutableArrayUsingWeakReferences];//
                    NSMutableArray* delegateArray = [[NSMutableArray alloc]init];
					// Add the delegate.
					if(delegate)
					{
						[delegateArray addObject:delegate];
					}
					// Add the array in the delegate Dictionary.
					[mDelegateDictionary setObject:delegateArray forKey:urlImage];
					// free memory.
					[delegateArray release];
                    
                    [NSThread detachNewThreadSelector:@selector(downloadImageToCache:) toTarget:self withObject:urlImage];

				}
				if(delegate != nil)
				{
					[delegate performSelector:@selector(willUpdateImage)];
				}
				
				return nil;
			}
		}
	}
	return nil;
}

- (void)removeDelegateForImage:(NSString*)_imageName
{
	if (_imageName != nil)
	{
		[mDelegateDictionary removeObjectForKey:_imageName];
	}
}

- (void)removeDelegate:(id)_delegate
{
    NSMutableArray* lKeyArray = [NSMutableArray array];
    for (NSString* key in [mDelegateDictionary allKeys])
    {
        NSMutableArray* delegateArray = [mDelegateDictionary valueForKey:key];
        [delegateArray removeObject:_delegate];
        if([delegateArray count]==0)
        {
            [lKeyArray addObject:key];
        }
    }
    for (NSString* key in lKeyArray)
    {
        [mDelegateDictionary removeObjectForKey:key];        
    }
}

- (void) fifoStack
{
    if ([[mDicoImage allKeys] count] > 40)
    {
        [mDicoImage removeObjectForKey:[mArrayKey objectAtIndex:0]];
        [mArrayKey removeObjectAtIndex:0];
    }
}


- (void) addImageViewInArray:(NSMutableArray*)urlImageArray
{
    [mDicoImage setValue:[urlImageArray objectAtIndex:0] forKey:[urlImageArray objectAtIndex:1]];
    [mArrayKey addObject:[urlImageArray objectAtIndex:1]];
    
    [self fifoStack];
}


- (void) downloadImageToCache:(NSString*)urlImage
{
	NSAutoreleasePool * pool	 = [[NSAutoreleasePool alloc] init];
	
	if (!(urlImage) || (urlImage == nil)) 
	{
		[pool drain];
		return;
	}
	
	NSURL *	 url  = [NSURL URLWithString:urlImage];
    NSError *error = nil;
	NSData * data = [[[NSData alloc] initWithContentsOfURL:url options: NSDataReadingMappedIfSafe error:&error] autorelease];

	if (data != nil && error== nil) 
	{
		UIImage *img = [[[UIImage alloc] initWithData:data] autorelease];
		if ( img != nil) 
		{
            [self performSelectorOnMainThread: @selector(addImageViewInArray:) withObject:[NSMutableArray arrayWithObjects:img,urlImage, nil] waitUntilDone:YES];	
            
			NSString * img_path = [[self applicationImagesDirectory] stringByAppendingPathComponent:[[urlImage stringByReplacingOccurrencesOfString:@":" withString:@"!"] stringByReplacingOccurrencesOfString:@"/" withString:@"!"]];
			NSError * error;
			if (![data writeToFile:img_path options:0 error:&error])
			{
				NSLog(@"-[ImageManager downloadImageToCache:] error %@",error);
			}
			
			if([mDelegateDictionary objectForKey:urlImage] != nil)
			{
				// Send for each delegate the image.
				[self performSelectorOnMainThread:@selector(delegateUpdatedImages:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:img,@"image",urlImage,@"url",nil] waitUntilDone:YES];
			}
			// remove the delegate array.
            [mDelegateDictionary performSelectorOnMainThread:@selector(removeObjectForKey:) withObject:urlImage waitUntilDone:true];
		}
	}
	else
	{
		if([mDelegateDictionary objectForKey:urlImage] != nil)
        {
            // Send for each delegate the image.
           //[self performSelectorOnMainThread:@selector(delegateUpdatedImages:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:urlImage,@"url",nil] waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(delegateUpdatedImages:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:nil,@"image",urlImage,@"url",nil] waitUntilDone:YES];
        }
		// remove the delegate array.
        [mDelegateDictionary performSelectorOnMainThread:@selector(removeObjectForKey:) withObject:urlImage waitUntilDone:true];
	}
	[pool drain];
}


-(void)delegateUpdatedImages:(NSDictionary*)_dic
{    
	NSString* urlImage = [_dic objectForKey:@"url"];
	UIImage* img = [_dic objectForKey:@"image"];
	
	NSMutableDictionary * lDicCopy = [[NSMutableDictionary alloc] initWithDictionary:mDelegateDictionary];
	for(NSObject<ImageManagerDelegate>* currentDelegate in [lDicCopy objectForKey:urlImage])
	{
		[currentDelegate performSelectorOnMainThread: @selector(didUpdateImage:) withObject:[NSArray arrayWithObjects:urlImage,img,nil] waitUntilDone:true];	
	}
	[lDicCopy release];
}




@end