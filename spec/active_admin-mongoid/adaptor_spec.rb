require 'spec_helper'

describe ActiveAdmin::Mongoid::Adaptor do
  describe ActiveAdmin::Mongoid::Adaptor::Search do
    let(:search_adaptor) { ActiveAdmin::Mongoid::Adaptor::Search }

    describe 'basic search adaptor' do
      subject { search_adaptor.new object }

      let(:object) { Post.new }

      its(:base) { should == object }
    end
  end
end
