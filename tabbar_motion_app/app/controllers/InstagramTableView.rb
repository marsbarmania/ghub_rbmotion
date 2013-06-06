class InstagramTabelView < UIViewController

  attr_accessor :photos

  def viewDidLoad
    super
    UIApplication.sharedApplication.delegate.dismiss_progress
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
    # {"website"=>"", "profile_picture"=>"http://images.instagram.com/profiles/profile_58658_75sq_1351145425.jpg",
    # "username"=>"dariszcahyadi", "id"=>"58658", "full_name"=>"DarisZ Cahyadi", "bio"=>"HDR Conspiracy Indonesia\r\n"}
    #cell.textLabel.text = @photos[indexPath.row]

    cell.textLabel.text = @photos[indexPath.row][:user]["username"]

    # add new prop :small_image property
    unless @photos[indexPath.row][:small_image]
      cell.imageView.image = nil
      url = @photos[indexPath.row][:images][:thumbnail][:url]
      Dispatch::Queue.concurrent.async{
        image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url))
        @photos[indexPath.row][:small_image] = UIImage.alloc.initWithData(image_data)

        if image_data
          # main queue
          Dispatch::Queue.main.async {
            # update process
            cell.imageView.image = @photos[indexPath.row][:small_image]
            reloadRowForPhoto @photos[indexPath.row]
          }
        end
      }

    else
      cell.imageView.image = @photos[indexPath.row][:small_image]
    end

    cell
  end

  # return the number of rows
  def tableView(tableView, numberOfRowsInSection: section)
    @photos.count
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


  def initWithNib(photos)
    initWithNibName(nil, bundle:nil)
    self.photos = photos
    self
  end

end
