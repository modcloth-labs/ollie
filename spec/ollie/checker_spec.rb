require 'spec_helper'

describe Ollie::Checker do
  describe 'initialize' do
    it 'takes a list of checks' do
      test = Ollie::Checker.new(:check)
      expect(test.checks).to include(:check)
    end
  end

  describe 'status' do
    it 'returns a hash' do
      expect(subject.status.class).to be(Hash)
    end
  end
end
