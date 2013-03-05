class TopViewController < UIViewController

  def viewDidLoad
    super
    self.title = 'Connection Status'
    self.view.backgroundColor = UIColor.cyanColor

    connect_status = Reachability.reachabilityForInternetConnection.currentReachabilityStatus

    alert_display = lambda do |message_text|
      alert = UIAlertView.alloc.init
      alert.message = "#{message_text}!"
      alert.addButtonWithTitle "OK"
      alert.show
    end

    message_text = ''
    case connect_status
    when NotReachable
      # p "Access Not Available"
      message_text = "Access Not Available"
    when ReachableViaWWAN
      # p "Reachable via WWAN"
      message_text = "Reachable via WWAN"
    when ReachableViaWiFi
      # p "Reachable via WiFi"
      message_text = "Reachable via WiFi"
    end

    alert_display.call(message_text)

    # show button
    @show = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @show.setTitle("Show Progress", forState:UIControlStateNormal)
    @show.sizeToFit
    @show.center = CGPointMake(self.view.frame.size.width / 2, 80)
    @show.when(UIControlEventTouchUpInside) do
      self.view.backgroundColor = UIColor.redColor
      self.showProgress
    end
    self.view.addSubview @show

    @show_with_str = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @show_with_str.setTitle("Show Progress with String", forState:UIControlStateNormal)
    @show_with_str.sizeToFit
    @show_with_str.center = CGPointMake(self.view.frame.size.width / 2, 140)
    @show_with_str.when(UIControlEventTouchUpInside) do
      self.view.backgroundColor = UIColor.redColor
      self.showProgress{"Loading something"}
    end
    self.view.addSubview @show_with_str

    # dismiss button
    @dismiss = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @dismiss.setTitle("Dismiss", forState:UIControlStateNormal)
    @dismiss.sizeToFit
    @dismiss.center = CGPointMake(self.view.frame.size.width / 2, 280)
    @dismiss.when(UIControlEventTouchUpInside) do
      self.view.backgroundColor = UIColor.cyanColor
      self.dismissProgress
    end
    self.view.addSubview(@dismiss)

    @dismiss_success = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @dismiss_success.setTitle("Dismiss Success", forState:UIControlStateNormal)
    @dismiss_success.sizeToFit
    @dismiss_success.center = CGPointMake(self.view.frame.size.width / 2, 360)
    @dismiss_success.when(UIControlEventTouchUpInside) do
      self.view.backgroundColor = UIColor.cyanColor
      self.dismissProgress{"Great Success!!"}
    end
    self.view.addSubview(@dismiss_success)


  end

  # https://github.com/samvermette/SVProgressHUD
  def showProgress

    unless block_given?
      SVProgressHUD.show
    else
      SVProgressHUD.showWithStatus "#{yield}"
    end

  end

  def dismissProgress

    unless block_given?
      SVProgressHUD.dismiss
    else
      SVProgressHUD.showSuccessWithStatus "#{yield}"
      # SVProgressHUD.showErrorWithStatus("Failed with Error")
    end


  end

end
