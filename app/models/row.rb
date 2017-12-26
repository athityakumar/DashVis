class Row < ApplicationRecord
  has_many :data, dependent: :destroy
  belongs_to :table, optional: true
end
