class Table < ApplicationRecord
  belongs_to :user, optional: true

  has_many :rows, dependent: :destroy
  has_many :charts, dependent: :destroy
  has_many :columns, dependent: :destroy

  has_many :collection_tables, dependent: :destroy
  has_many :collections, through: :collection_tables, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :description

  def to_dataframe
    df = Daru::DataFrame.rows(
      rows.map    { |row| row.data.map(&:value) },
      order: columns.map { |col| col.name.gsub(' ', '_') },
      index: rows.map { |row| row.id }
    )

    df['SNo'] = (1..df.nrows).to_a
    df
  end
end
