class SampleMail < MailForm::Base
  attributes :name, :email

  def headers
    { to: "recipent@example.com", from: self.email }
  end
end