class Instagram

  PROPERTIES = [:id, :name, :link, :attribution,
                :tags, :location, :caption, :type,
                :images, :filter, :comments, :user,
                :created_time, :likes]

  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  def initialize(hash = [])

    hash.each do |key, value|
      if PROPERTIES.member?(key.to_sym)
        self.send((key.to_s + "=").to_s, value)
      end
    end
  end

  def self.find(keyword, &block)

    data = Array.new
    BW::HTTP.get("http://www.marsbar.us/api/#{keyword}/100") do |response|
      json = BW::JSON.parse(response.body.to_str)
      json.each do |media|
        h = Hash.new
        h.store(:user, media["user"])
        h.store(:images, media["images"])
        data << h
      end
      block.call(data)
    end

  end


end
