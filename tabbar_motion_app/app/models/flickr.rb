class Flickr

  PROPERTIES = [:page, :pages, :perpage, :total, :photo, :stat, :perpage]

  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  API_KEY = "YOUR_FLIKR_API_KEY"

  def initialize(hash = {})
    hash.each do |key,val|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, val)
      end
    end
  end

  def photo
    # Nil guard
    @photo ||= []
  end

  def photo=(photo)

    if photo.first.is_a? Hash
      # add data as Photo Class Object
      photo = photo.collect {|obj| Photo.new(obj)}
    end

    photo.each do |img|
      if not img.is_a? Photo
        raise "wrong class for attemted tag #{img.inspect}"
      end
    end

    @photo = photo

  end

  def self.find(keyword, &block)
    d_hash = {method: "flickr.photos.search", api_key: "#{API_KEY}", tags: "#{keyword}", format: "json", per_page: "200"}

    BW::HTTP.get("http://api.flickr.com/services/rest/", payload: d_hash ) do |response|

      response = response.body.to_str.sub(/^jsonFlickrApi\(/,"")
      response = response.sub(/\)$/,"")
      #block.call(nil)

      result_data = BW::JSON.parse(response)

      response_hash = result_data["photos"]

      flickr_obj = Flickr.new(response_hash)
      # block call here
      block.call(flickr_obj)

    end

  end

end
