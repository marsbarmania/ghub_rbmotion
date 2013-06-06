class TopController < UIViewController

  def viewDidLoad
    super
    the_bar_height = 44

    self.view.backgroundColor = UIColor.colorWithRed(0.46, green:0.81, blue:0.86, alpha:1.0)
    self.title = "Image Search"
    @search_bar = UISearchBar.alloc.initWithFrame(CGRectMake(0, 0,self.view.bounds.size.width, the_bar_height))
    @search_bar.placeholder = "Place keyword here"
    @search_bar.setShowsCancelButton(true, animated:true)

    @search_bar.resignFirstResponder
    @search_bar.delegate = self

    self.view.addSubview(@search_bar)

    instg_logo = UIImage.imageNamed("instagram.png")
    @instg_logo_view = UIImageView.alloc.initWithImage(instg_logo)
    @instg_logo_view.frame = CGRectMake( 0, (20 + the_bar_height), self.view.frame.size.width, instg_logo.size.height / 2 )
    @instg_logo_view.contentMode = UIViewContentModeScaleAspectFit
    self.view.addSubview(@instg_logo_view)

    @binstgrm = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @binstgrm.setTitle("Popular",forState:UIControlStateNormal)
    @binstgrm.sizeToFit
    @binstgrm.center = CGPointMake(self.view.frame.size.width / 2,
                                  @instg_logo_view.center.y + @instg_logo_view.size.height + 20)
    self.view.addSubview(@binstgrm)

    flickr_logo = UIImage.imageNamed("flickr.png")
    @flickr_logo_view = UIImageView.alloc.initWithImage(flickr_logo)
    @flickr_logo_view.frame = CGRectMake( 0, @binstgrm.center.y + @binstgrm.size.height, self.view.frame.size.width, flickr_logo.size.height / 2)
    @flickr_logo_view.contentMode = UIViewContentModeScaleAspectFit
    self.view.addSubview(@flickr_logo_view)

    @bflickr= UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @bflickr.setTitle("Flickr API",forState:UIControlStateNormal)
    @bflickr.sizeToFit
    @bflickr.center = CGPointMake(self.view.frame.size.width / 2,
                                  @flickr_logo_view.center.y + @flickr_logo_view.size.height + 20)
    self.view.addSubview(@bflickr)

    # ======================================
    # Flickr API Button
    # ======================================
    @bflickr.when(UIControlEventTouchUpInside) do

      if connect_status[0]

        unless @search_bar.text.nil? or @search_bar.text.empty?
          UIApplication.sharedApplication.delegate.show_progress{"accessing api"}

          Flickr.find(@search_bar.text) do |flickr_obj|
            # Array of PhotoClass
            open_flickr_view(flickr_obj.photo)
          end
        else
          self.alert_message{"No keyword found!"}
        end
      else
        # NotReachable
        self.alert_message{"#{connect_status[1]}"}
      end

    end

    # ======================================
    # Flickr API Button
    # ======================================
    @binstgrm.when(UIControlEventTouchUpInside) do

      if connect_status[0]
        UIApplication.sharedApplication.delegate.show_progress{"accessing api"}
        Instagram.find("popular"){ |response|
          # Array:Popular Instagram
          open_instgram_view(response)
        }
      else
        # NotReachable
        self.alert_message{"#{connect_status[1]}"}
      end
    end
  end


  def alert_message
      alert = UIAlertView.alloc.init
      alert.message = "#{yield}"
      alert.addButtonWithTitle "OK"
      alert.show
  end

  def connect_status
    status = Reachability.reachabilityForInternetConnection.currentReachabilityStatus
    message, flag = '',true
    case status
    when NotReachable
      flag = false
      message = "Access Not Available"
    when ReachableViaWWAN
      message = "Reachable via WWAN"
    when ReachableViaWiFi
      message = "Reachable via WiFi"
    end
    return flag, message
  end

  def searchBarCancelButtonClicked(searchBar)
    #p "searchBarCancelButtonClicked"
    searchBar.resignFirstResponder
    searchBar.text = ""
  end

  def searchBarSearchButtonClicked(searchBar)
    #p "searchBarSearchButtonClicked"
    #@search_wd = searchBar.text
    searchBar.resignFirstResponder
  end

  def open_flickr_view(photo_obj)
    p "open flickr view"
    @search_bar.text = nil
    self.navigationController.pushViewController(FlickrTableView.alloc.initWithFlickrTable(photo_obj), animated:true)
  end

  def open_instgram_view(photo_obj)
    @search_bar.text = nil
    p "open instgram view"

    self.navigationController.pushViewController(InstagramTabelView.alloc.initWithNib(photo_obj), animated:true)
  end

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
    self

  end


end
