require "uri"

class ContactInquiry
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :first_name, :string
  attribute :email, :string
  attribute :telephone, :string
  attribute :message, :string
  attribute :website, :string

  validates :name, :first_name, :email, :telephone, :message,
            presence: { message: "Ce champ est obligatoire." }
  validates :name, :first_name,
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

  def full_name
    [first_name, name].compact_blank.join(" ")
  end
end
