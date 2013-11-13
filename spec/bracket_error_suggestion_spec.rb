require 'spec_helper'

describe BracketErrorSuggestion do
  it 'should have a version number' do
    BracketErrorSuggestion::VERSION.should_not be_nil
  end

  let(:tree) do
    {
      foo1: {bar1: :baz1},
      "foo2" => [{"bar1" => :baz1}, {"bar2" => :baz2}],
    }
  end

  context :disabled do
    it{ tree[:foo1].should be_a(Hash) }
    it{ tree[:foo1][:bar1].should == :baz1 }
    it{ tree[:foo1][:bar2].should be_nil }
    it{ tree["foo2"][99].should be_nil }
    it "raises NoMethodError" do
      expect{ tree[:foo1][:bar2][:baz2] }.to raise_error(NoMethodError, "undefined method `[]' for nil:NilClass")
    end
    it "raises TypeError" do
      expect{ tree["foo2"][99] }.to raise_error(TypeError, "undefined method `[]' for nil:NilClass")
    end
  end

end
