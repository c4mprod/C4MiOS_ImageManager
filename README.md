C4MiOS ImageManager
=================



Description
-----------
* Image Manager download images from url.
* It use cache to store downloaded images.
* It also check modification date on server side when image is requested to be up to date.

Change Logs
-----------

### v4.1

Fix a bug on modification date.

### v4

Major changes :

1. The modification date check was performed synchronously on the main thread. It is now threaded.
2. Formatting rules applied.
3. New methods are available :
* getImageNamed: withTimeIntervalBetweenModificationCheck: withDelegate: use this method to specify the time between modification date check you wish.
* All methods were implemented as Class methods.
* getImageNamed: withDelegate: is still also an instance method for retro-compatibility purpose.
4. ImageManager now uses NSNotifications instead of delegates (ensure no leaks).

The ImageManager handle the subscription of the delegate to NSNotificationCenter. To avoid crash, ImageViewManager was also updated.
If you wish to use another object as delegate of the ImageManager, you must unregister it in its dealloc method :

	[[NSNotificationCenter defaultCenter] removeObserver:self];

### v3

Add a check on images modification date (server side) when image is requested.