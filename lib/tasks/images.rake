namespace :images do
  desc "Generate missing responsive WebP derivatives for existing Shrine images"
  task generate_derivatives: :environment do
    failures = []
    attachments = Photo.find_each.map { |photo| [photo, :image] }
    attachments.concat(
      Gite.where.not(main_photo_data: nil).find_each.map { |gite| [gite, :main_photo] }
    )

    attachments.each_with_index do |(record, attachment), index|
      attacher = record.public_send(:"#{attachment}_attacher")
      missing = %i[small medium large] - attacher.derivatives.keys

      if missing.empty?
        puts "[#{index + 1}/#{attachments.size}] #{record.class}##{record.id}: already processed"
        next
      end

      attacher.create_derivatives
      attacher.atomic_persist
      record.gite&.touch if record.is_a?(Photo)
      record.home_page&.touch if record.is_a?(Photo)
      puts "[#{index + 1}/#{attachments.size}] #{record.class}##{record.id}: generated"
    rescue StandardError => e
      failures << "#{record.class}##{record.id}: #{e.message}"
      warn "[#{index + 1}/#{attachments.size}] #{record.class}##{record.id}: #{e.message}"
    end

    abort "Derivative generation failed:\n#{failures.join("\n")}" if failures.any?
  end
end
