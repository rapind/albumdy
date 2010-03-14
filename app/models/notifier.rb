class Notifier < ActionMailer::Base  
  
  def administrator_password_reset_instructions(administrator)
    subject       "Password Reset Instructions - #{administrator.site_name}"
    from          administrator.site_email
    recipients    administrator.email
    sent_on       Time.now
    body          :edit_administrator_password_reset_url => edit_admin_administrator_password_reset_url(administrator.perishable_token)
  end
  
  def administrator_welcome(administrator, unencrypted_password)
    subject       "Welcome - #{administrator.site_name}"
    from          administrator.site_email
    recipients    administrator.email
    sent_on       Time.now
    body          :admin => admin_url, :email => administrator.email, :unencrypted_password => unencrypted_password
  end
  
end