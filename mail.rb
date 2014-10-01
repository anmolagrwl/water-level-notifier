require 'rubygems'
require 'mail'

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'your.host.name',
            :user_name            => 'gmail address',
            :password             => 'password',
            :authentication       => 'plain',
            :enable_starttls_auto => true  
        }
Mail.defaults do
  delivery_method :smtp, options
end

mail = Mail.new do
  from    'anmol1771@gmail.com'
  to      'anmol@interaction-design.org'
  subject 'This is a test email'
  body    'And this is the body of this test email.'
end

mail.to_s #=> "From: mikel@test.lindsaar.net\r\nTo: you@...

mail.deliver!