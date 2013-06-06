class ThirdController < UIViewController

  def loadView
    self.view = UIWebView.alloc.init
  end

  def viewDidLoad
    super
    self.title = "WebView"

    # Creating a URL
    url = NSURL.URLWithString("http://rubymotion-tutorial.com/")
    # Creating a request based on the URL
    request = NSURLRequest.requestWithURL(url)
    # Loading the request into the view (that is set to be our UIWebView)
    self.view.loadRequest(request)
  end

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemMostViewed, tag: 3)
    self

  end

end
