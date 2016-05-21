require "rails_helper"

RSpec.describe ForgotPasswordMailer, :type => :mailer do
  describe "forgot_password_email" do
    let(:mail) { ForgotPasswordMailer.forgot_password_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Forgot password email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
