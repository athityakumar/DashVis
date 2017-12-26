class Chart < ApplicationRecord
  belongs_to :table, optional: true
end
