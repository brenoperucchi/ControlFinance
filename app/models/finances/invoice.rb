class Finances::Invoice < ApplicationRecord
  belongs_to :invoiceable
end
