require 'spec_helper'

class OllieControllerTest
  include Ollie::Controller

  def render(*params)
    # stand in for action controller's render
  end
end

describe Ollie::Controller do
  subject { OllieControllerTest.new }
  before(:each) do
  end
  describe 'server status' do
    it 'uses an ollie checker' do
      subject.stub(:render)    
      subject.should_receive(:ollie_checker).once
      subject.server_status
    end
    it 'renders the ollie checker object' do
      subject.should_receive(:render).with({ json: kind_of(Ollie::Checker) })
      subject.server_status
    end    
  end
end
