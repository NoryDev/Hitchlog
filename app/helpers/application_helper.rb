module ApplicationHelper
  def javascript_google_stats
    render :partial => 'shared/google_stats'
  end
  
  def uservoice_feedback
    render :partial => 'shared/uservoice_feedback'
  end
  
  def user_image
    image_tag("icons/user.png")
  end
end
