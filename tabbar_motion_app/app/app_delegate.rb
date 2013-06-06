class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    top_controller = TopController.alloc.initWithNibName(nil, bundle:nil)
    #@window.rootViewController = UINavigationController.alloc.initWithRootViewController(top_controller)
    nav_controller = UINavigationController.alloc.initWithRootViewController(top_controller)

    second_controller = SecondController.alloc.initWithNibName(nil, bundle:nil)
    nav2_controller = UINavigationController.alloc.initWithRootViewController(second_controller)

    third_controller = ThirdController.alloc.initWithNibName(nil, bundle:nil)
    nav3_controller = UINavigationController.alloc.initWithRootViewController(third_controller)

    fourth_controller = FourthController.alloc.initWithNibName(nil, bundle:nil)
    nav4_controller = UINavigationController.alloc.initWithRootViewController(fourth_controller)

    tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle:nil)
    tab_controller.viewControllers = [nav_controller, nav2_controller,nav3_controller,nav4_controller]
    @window.rootViewController = tab_controller


    true
  end

  def photo_details_controller
    @photo_details_controller ||= ImageDetailView.alloc.init
  end

  def show_progress
    unless block_given?
      SVProgressHUD.show
    else
      SVProgressHUD.showWithStatus "#{yield}"
    end
  end

  def dismiss_progress
    unless block_given?
      SVProgressHUD.dismiss
    else
      SVProgressHUD.showSuccessWithStatus "#{yield}"
      # SVProgressHUD.showErrorWithStatus("Failed with Error")
    end
  end

end
