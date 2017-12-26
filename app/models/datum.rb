class Datum < ApplicationRecord
  belongs_to :row, optional: true
  belongs_to :column, optional: true
end
