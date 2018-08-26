FactoryBot.define do
  factory :mailer_sender do
    to { "MyString" }
    token { "MyString" }
    information { "MyText" }
  end
end
