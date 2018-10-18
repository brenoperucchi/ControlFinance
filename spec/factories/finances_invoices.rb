FactoryBot.define do
  factory :finances_invoice, class: 'Finances::Invoice' do
    invoiceable nil
    amount "9.99"
  end
end
