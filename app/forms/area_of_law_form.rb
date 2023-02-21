class AreaOfLawForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = [:area_of_law].freeze

  AREAS_OF_LAW = %w[asylum immigration domestic_abuse other_area_of_law].freeze

  attribute :area_of_law
  validates :area_of_law, presence: true, inclusion: { in: AREAS_OF_LAW }
end
