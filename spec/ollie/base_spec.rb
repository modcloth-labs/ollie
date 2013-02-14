require 'spec_helper'

describe Ollie::Base do
  before(:each) do
    class TestClass < Ollie::Base
    end
  end

  describe ".metrics" do
    subject { Ollie::Base.new }

    it 'defaults to an empty array' do
      expect(Ollie::Base.metrics).to be_empty
    end

    context "metrics have been added" do
      before { TestClass.metric :one }

      it 'returns the stored metrics' do
        expect(TestClass.metrics).to include(:one)
      end
    end
  end

  describe '.metric' do
    before {   TestClass.metric :test_metric    }
    it 'defines metrics for the class' do
      expect(TestClass.metrics).to include :test_metric
    end
  end

  describe "#metrics" do
    before {   TestClass.metric :test_metric    }
    it "gets the class-level metrics" do
      expect(TestClass.new.metrics).to equal(TestClass.metrics)
    end
  end

  describe '.to_hash' do
    before(:each) do
      class TestClass < Ollie::Base
        metric :good_metric, :bad_metric

        def good_metric
          'good_metric'
        end

        def bad_metric
          raise 'bad test'
        end
      end
    end
    it 'runs each of the metrics' do
      test_class = TestClass.new      
      test_class.should_receive(:good_metric).once.and_call_original
      test_class.should_receive(:bad_metric).once.and_call_original
      test_class.to_hash
    end

    it 'creates a key for each metric' do
      test_class = TestClass.new
      expect(test_class.to_hash.keys).to include :good_metric, :bad_metric
    end

    it 'stores the value of each metric' do
      test_class = TestClass.new
      test_class.should_receive(:good_metric).once.and_call_original
      hash = test_class.to_hash
      expect(hash[:good_metric]).to eq('good_metric')
    end

    it 'creates an errors key' do
      expect(subject.to_hash.keys).to include(:errors)
    end

    it 'stores metric errors in the errors key' do
      test_class = TestClass.new
      hash = test_class.to_hash
      expect(hash[:errors]).to include('bad test')
    end
  end

  describe '.metric_group_name' do
    it 'uses the base class name' do
      subject.class.should_receive(:to_s).once.and_return('base_class')
      subject.metric_group_name
    end
  end
end

