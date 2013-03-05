# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'
require 'bubble-wrap/ui'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'pod'
  app.identifier = 'us.marsbar.cocoapods'
  app.frameworks += ['QuartzCore']
  app.pods do
    pod 'JSONKit'
    pod 'Reachability'
    pod 'SVProgressHUD'
  end
end
