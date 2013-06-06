class FourthController < UIViewController

  def viewDidLoad
    super
    self.title = "aaaa"
    self.view.backgroundColor = UIColor.whiteColor

    leftButton = UIBarButtonItem.alloc.initWithTitle("Push", style: UIBarButtonItemStyleBordered, target:self, action:'push_left')
    self.navigationItem.leftBarButtonItem = leftButton



  end


  def push_left
    p "push_left"
  end

# Override initWithNibName:bundle
  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemBookmarks, tag: 4)
    self

  end

end
