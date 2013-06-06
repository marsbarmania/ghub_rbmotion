class FlickrTableView < UIViewController

  attr_accessor :photos

  def viewDidLoad
    super
    UIApplication.sharedApplication.delegate.dismiss_progress
    # CGPointMake(self.view.frame.size.width, self.view.frame.size.height))
    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.dataSource = self
    @table.delegate = self

    self.view.addSubview @table

  end

  # return the UITableViewCell for the row
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end

    #======== Add accessoryType to Button
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
    #cell
    #=======end

    # put your data in the cell
    #cell.textLabel.text = @photos[indexPath.row]
    cell.textLabel.text = "#{@photos[indexPath.row].title}"
    photo = @photos[indexPath.row]

    unless @photos[indexPath.row].small_image
      cell.imageView.image = nil
      url = "http://farm#{photo.farm}.staticflickr.com/#{photo.server}/#{photo.id}_#{photo.secret}_s.jpg"
      Dispatch::Queue.concurrent.async do
         # 処理
        flickr_image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url))
        @photos[indexPath.row].small_image = UIImage.alloc.initWithData(flickr_image_data)

        if flickr_image_data
          Dispatch::Queue.main.async do
             # Update UI
             cell.imageView.image = @photos[indexPath.row].small_image
             reloadRowForPhoto(photo)
           end
        end
      end
    else
      cell.imageView.image = photo.small_image
    end

    cell
  end

  # return the number of rows
  def tableView(tableView, numberOfRowsInSection: section)
    @photos.count
  end

  def initWithFlickrTable(photos)
    initWithNibName(nil, bundle:nil)
    self.photos = photos
    self
  end

   # Action for press the cell
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    moveDetail(indexPath.row)
  end

  # AccesoryButton Action
  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    moveDetail(indexPath.row)
  end

  def moveDetail(index)
    photo = @photos[index]
    controller = UIApplication.sharedApplication.delegate.photo_details_controller
    navigationController.pushViewController(controller, animated:true)
    controller.showDetail(photo)
  end

  def reloadRowForPhoto(photo)
    row = @photos.index(photo)
    if row
      @table.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end

  end

end
