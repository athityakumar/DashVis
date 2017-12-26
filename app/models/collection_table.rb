class CollectionTable < ApplicationRecord
  belongs_to :collection, optional: true
  belongs_to :table, optional: true
end
