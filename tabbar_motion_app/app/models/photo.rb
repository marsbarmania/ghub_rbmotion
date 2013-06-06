class Photo
  attr_accessor :small_image, :normal_image
  PROPERTIES = [:id, :owner, :secret, :title, :ispublic, :isfamily, :isfriend, :farm, :server]
  PROPERTIES.each {|prop| attr_accessor prop}

  def initialize(hash = {})
    hash.each {|key,value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
    @small_image = nil
    @normal_image = nil
  end

end
