module ImageHelper
  def images_for_hitchhike(hitchhike)
    array = []
    array << photo_image if hitchhike.photo.file?
    array << driver_image(hitchhike.person.gender) if hitchhike.person
    array << story_image if hitchhike.story
    unless hitchhike.trip.travelling_with.nil?
      case hitchhike.trip.travelling_with
      when 0
        array << alone_image
      when 1
        array << two_people_image
      when 2
        array << three_people_image
      else
        array << more_than_three_people_image
      end
    end
    string = array.join(' ')
    string.html_safe 
  end

  def alone_image
    image_tag("icons/alone.png", :class => 'tooltip', :alt => t('trips.helper.alone'))
  end

  def two_people_image
    image_tag("icons/two_people.png", :class => 'tooltip', :alt => t('trips.helper.two'))
  end

  def three_people_image
    image_tag("icons/three_people.png", :class => 'tooltip', :alt => t('trips.helper.three'))
  end

  def more_than_three_people_image  
    image_tag("icons/more_than_three_people.png", :class => 'tooltip', :alt => t('trips.helper.more_than_three'))
  end

  def driver_image(gender)
    if gender == 'male'
      image_tag("icons/male.png", :class => 'tooltip', :alt => t('trips.helper.male_driver'))
    else
      image_tag("icons/female.png", :class => 'tooltip', :alt => t('trips.helper.female_driver'))
    end
  end

  def user_image
    image_tag("icons/user.png", :class => 'tooltip')
  end
  
  def photo_image
    image_tag("icons/photo.png", :class => 'tooltip', :alt => t('trips.helper.photo'))
  end
  
  def story_image
    image_tag("icons/story.png", :class => 'tooltip')
  end
  
  def add_image
    image_tag('icons/add.png', :class => 'tooltip', :alt => t('trips.helper.add_information'))
  end
end
