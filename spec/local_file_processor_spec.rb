require_relative './spec_helper'
require_relative '../lib/controller'

describe 'remote files processor' do
  context  'remote file : https://www.w3.org/TR/PNG/iso_8859-1.txt' do
    let(:processor) { WordsCounter::LocalFileProcessor.new('./sample_data/data.txt') }
    let(:controller) {WordsCounter::Controller.new(nil) }

    before do
      processor.process
    end

    it 'should be able return correct count' do
      result = controller.retrieve_stats 'talk'
      expect(result ).to eql(2)
    end

    it 'should be able to return 0 in case of missing word' do
      result = controller.retrieve_stats 'talkkkk'
      expect(result ).to eql(0)
    end
  end
end

