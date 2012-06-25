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

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import "ImageManagerDelegate.h"

@interface ImageManager : NSObject//<C4MRequestDelegate>

@property (nonatomic, retain) NSMutableDictionary* mDicoImage;
@property (nonatomic, retain) NSMutableDictionary* mDelegateDictionary;
@property (nonatomic, retain) NSMutableArray*      mArrayKey;

- (NSString *)     applicationImagesDirectory;
- (UIImage *)	   getImageNamed:(NSString *)urlImage withDelegate:(NSObject<ImageManagerDelegate> *)delegate;
- (void)		   fifoStack;
- (void)		   removeDelegateForImage:(NSString*)_imageName;
- (void)           removeDelegate:(id)_delegate;
+ (ImageManager *) sharedImageManager;

@end