class Collection < ApplicationRecord
  belongs_to :user, optional: true

  has_many :collection_tables, dependent: :destroy
  has_many :tables, through: :collection_tables, dependent: :destroy
end
