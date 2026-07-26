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
            :desired_dates, :package, :message,
            presence: { message: "Ce champ est obligatoire." }
  validates :company, :contact_name,
            length: {
              maximum: 120,
              message: "Utilisez 120 caractères maximum.",
            },
            allow_blank: true
  validates :email,
            length: {
              maximum: 254,
              message: "Utilisez 254 caractères maximum.",
            },
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "Saisissez une adresse e-mail valide.",
            },
            allow_blank: true
  validates :telephone,
            length: {
              maximum: 40,
              message: "Utilisez 40 caractères maximum.",
            },
            allow_blank: true
  validates :participants,
            numericality: {
              only_integer: true,
              message: "Indiquez un nombre entier.",
            },
            allow_nil: true
  validates :participants,
            numericality: {
              greater_than: 0,
              message: "Le nombre de participants doit être supérieur à 0.",
            },
            allow_nil: true
  validates :participants,
            numericality: {
              less_than_or_equal_to: 100,
              message: "Le nombre de participants ne peut pas dépasser 100.",
            },
            allow_nil: true
  validates :desired_dates,
            length: {
              maximum: 200,
              message: "Utilisez 200 caractères maximum.",
            },
            allow_blank: true
  validates :package,
            inclusion: {
              in: PACKAGE_OPTIONS.values,
              message: "Choisissez l’une des formules proposées.",
            },
            allow_blank: true
  validates :message,
            length: {
              minimum: 10,
              too_short: "Donnez-nous un peu plus de détails (10 caractères minimum).",
              maximum: 3_000,
              too_long: "Votre message ne peut pas dépasser 3 000 caractères.",
            },
            allow_blank: true

  def mailer_payload
    attributes.except("website")
  end

  def package_label
    PACKAGE_OPTIONS.key(package) || package
  end
end
