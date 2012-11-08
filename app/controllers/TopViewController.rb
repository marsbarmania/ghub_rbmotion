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

  end

end
