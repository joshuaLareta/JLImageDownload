JLImageDownload
===============

A class that handles image download using completion blocks (GCD) and can work hand in hand with operation queues

Properties
----------

* ``delegate``
   * A delegate used for callback after downloading the image.
   * Used for single image download

Parameters
----------

* ``downloadImageLink``
   * The imageLink that needs to be downloaded
   
* ``forView``
   * The current view showing
   * Used to display the loading notification
   
* ``optionalParam``
   * A dictionary passed to the downloader then retrieved back from the delegate method
   * Since the downloader runs in an operation queue we can pass details/data about the image in this parameter and retrieve it in the callback method
   
Callback
--------

* ``-(void)downloadFinished:(UIImage *)JLImage withParams:(NSMutableDictionary *)param``
    * The callback method if single image download is used
    * ``JLImage`` is the downloaded image
    * ``param`` is the dictionary that contains details/data about the image, passed during method call


Usage
-----

<b>Single image download</b>
* It is better to use ``[JLImageDLInstance downloadImageLink:@"imageLink" forView:self.view optionalParam:dictionary];`` if you are only downloading a single image.

<b>Steps:</b> 

1) Include JLImageDL.h

2) Add the protocol ``JLImageDLDelegate``

3) Instantiate a new ```JLImageDL *jlImage = [JLImageDL new]``` object.

4) Set the delegate ``jlImage.delegate = self``

5) Call ``[JLImageDLInstance downloadImageLink:@"imageLink" forView:self.view optionalParam:params];``

6) The callback function will be called after the download finishes

<b>Image download using a block</b>
* It is useful in downloading image inside a loop (tableview). It uses GCD to download the images and calls the completion when its done.

<b>Steps:</b>

1) Include JLImageDL.h

2) call 

    [JLImageDL downloadImageLinkBlock:[images objectAtIndex:indexPath.row] forView:cv completion:^(UIImage *image) {

              //do something with the image
    }];
            

Credits
-------
I'd appreciate it to mention the use of this code in your project. On a website, in an about page, in the app itself, whatever. Or let me know by email or through github. It's nice to know that it is being used.


