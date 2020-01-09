require 'spec_helper'

RSpec.describe ContentfulLite::Entry do
  let(:instance) { ContentfulLite::Entry.new(JSON.parse(File.read('fixtures/entries/nyancat.json')), []) }

  describe '#attributes' do
    it { expect(instance.id).to eq 'nyancat' }
    it { expect(instance.created_at).to eq DateTime.new(2013, 6, 27, 22, 46, 19.513) }
    it { expect(instance.updated_at).to eq DateTime.new(2013, 9, 4, 9, 19, 39.027) }
    it { expect(instance.locale).to eq 'en-US' }
    it { expect(instance.revision).to eq 5 }
    it { expect(instance.space_id).to eq 'cfexampleapi' }
    it { expect(instance.environment_id).to eq 'master' }
    it { expect(instance.content_type_id).to eq 'cat' }
    it { expect(instance.fields).to be_a Hash }
  end

  describe '#contentful_link' do
    subject { instance.contentful_link }

    it { is_expected.to eq 'https://app.contentful.com/spaces/cfexampleapi/entries/nyancat' }
  end
end
