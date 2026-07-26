require "uri"

class TeamBuildingInquiry
  include ActiveModel::Model
  include ActiveModel::Attributes

  PACKAGE_OPTIONS = {
    "Journée sans hébergement" => "day",
    "Séjour avec hébergement" => "residential",
    "À définir ensemble" => "unsure",
  }.freeze

  attribute :company, :string
  attribute :contact_name, :string
  attribute :email, :string
  attribute :telephone, :string
  attribute :participants, :integer
  attribute :desired_dates, :string
  attribute :package, :string
  attribute :message, :string
  attribute :website, :string

  validates :company, :contact_name, :email, :telephone, :participants,
            :desired_dates, :package, :message, presence: true
  validates :company, :contact_name, length: { maximum: 120 }
  validates :email, length: { maximum: 254 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :telephone, length: { maximum: 40 }
  validates :participants, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: 100,
  }
  validates :desired_dates, length: { maximum: 200 }
  validates :package, inclusion: { in: PACKAGE_OPTIONS.values }
  validates :message, length: { minimum: 10, maximum: 3_000 }

  def mailer_payload
    attributes.except("website")
  end

  def package_label
    PACKAGE_OPTIONS.key(package) || package
  end
end
