class ImageDetailView < UIViewController

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.blackColor
    @init_rect = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-navigationController.toolbar.frame.size.height-navigationController.navigationBar.frame.size.height)
    @scroll_view = UIScrollView.alloc.initWithFrame(@init_rect)
    @detail_image_view = UIImageView.alloc.initWithFrame(@init_rect)

    #@detail_image_view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
    @detail_image_view.contentMode = UIViewContentModeScaleAspectFit

    # enable scrolling
    @scroll_view.contentSize = @detail_image_view.frame.size
    @scroll_view.delegate = self;
    @scroll_view.minimumZoomScale = 1.0
    @scroll_view.maximumZoomScale = 5.0

    # self.view.addSubview(@detail_image_view)
    @scroll_view.addSubview(@detail_image_view)
    self.view.addSubview(@scroll_view)
  end

  # デリゲート関数viewForZoomingInScrollViewで、拡大縮小したいViewを返せば完成
  def viewForZoomingInScrollView(scrollView)
    return @detail_image_view
  end

  # Event After Scaling
  def scrollViewDidZoom(scrollView)
    centerScrollViewContents
  end

  # See here: http://www.raywenderlich.com/10518/how-to-use-uiscrollview-to-scroll-and-zoom-content
  def centerScrollViewContents
    boundsSize = @scroll_view.bounds.size
    contentsFrame = @detail_image_view.frame
    if contentsFrame.size.width < boundsSize.width
      contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
    else
      contentsFrame.origin.x = 0.0
    end

    if contentsFrame.size.height < boundsSize.height
      contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
    else
      contentsFrame.origin.y = 0.0
    end
    @detail_image_view.frame = contentsFrame
  end

  def viewWillAppear(animated)
    super
    navigationController.setNavigationBarHidden(false, animated:true)
  end

  def viewWillDisappear(animated)
    if  @detail_image_view.image
      @detail_image_view.image = nil
      # reset scaling
      @scroll_view.zoomScale = 1.0
    end
  end

  def showDetail(photo)

    title = ''
    normal_image = nil
    if photo.instance_of?(Hash)

      title, url = photo[:user][:username], photo[:images][:standard_resolution][:url]
    else
      title, url = photo.title, "http://farm#{photo.farm}.staticflickr.com/#{photo.server}/#{photo.id}_#{photo.secret}.jpg"
    end

    # set
    navigationItem.title = title
    # load image
    UIApplication.sharedApplication.delegate.show_progress{"image loading..."}
    unless normal_image
      Dispatch::Queue.concurrent.async do
        d_image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url))
        normal_image = UIImage.alloc.initWithData(d_image_data)
        if d_image_data
          Dispatch::Queue.main.async do
            UIApplication.sharedApplication.delegate.dismiss_progress
            @detail_image_view.image = normal_image
          end
        end
      end
    else
      # set loaded image here
      UIApplication.sharedApplication.delegate.dismiss_progress
    end

  end

end
