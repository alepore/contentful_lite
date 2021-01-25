module ContentfulLite
  module CommonData
    attr_reader :id, :created_at, :updated_at, :default_locale, :revision, :space_id, :environment_id, :retrieved_at, :locales, :localized_fields, :sys

    def initialize(raw)
      @sys = raw['sys']
      @id = sys['id']
      @created_at = DateTime.parse sys['createdAt']
      @updated_at = DateTime.parse sys['updatedAt']
      @locale = sys['locale']
      @revision = sys['revision']
      @space_id = sys['space']['sys']['id']
      @environment_id = sys['environment']['sys']['id']
      @retrieved_at = DateTime.now

      if locale
        @locales = [locale]
        @localized_fields = { locale => raw['fields'] }
      else
        @locales = raw.fetch('fields', {}).values.collect_concat(&:keys).uniq
        @localized_fields = @locales.each_with_object({}) do |locale, hash|
          hash[locale] = raw['fields'].transform_values { |value| value[locale] }
        end
      end

      @default_locale = @locales.first
    end

    def locale
      @locale || @default_locale
    end

    def locale=(value)
      raise 'Invalid Locale' unless value.in?(locales)

      @locale = value
    end

    def fields(locale: nil)
      @localized_fields.fetch(locale || self.locale, {})
    end

    def with_locale(locale)
      old_locale = @locale
      @locale = locale unless locale.nil?
      begin
        yield
      ensure
        @locale = old_locale
      end
    end

    def to_link
      ContentfulLite::Link.new(self)
    end

    def as_json(serialized_ids: [], **options)
      if serialized_ids.include?(id)
        to_link.as_json
      else
        {
          sys: sys,
          fields: fields.transform_values do |value|
            if value.is_a?(ContentfulLite::CommonData)
              value.as_json(serialized_ids: serialized_ids + [id], **options)
            else
              value
            end
          end
        }
      end
    end
  end
end
