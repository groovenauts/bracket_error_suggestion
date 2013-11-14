require 'spec_helper'

describe BracketErrorSuggestion do
  it "suggests the place where invalid access happens" do
    tree = {foo: { bar: [{baz: "foo"}] }  }

    BracketErrorSuggestion.enable do
      expect{ tree[:foo][:bar][:baz] }.to raise_error(TypeError, "no implicit conversion of Symbol into Integer, it attempted to access <Hash>[:foo][:bar][:baz] but <Hash>[:foo][:bar] is an Array")
      expect{ tree[:foo][:baz][:bar] }.to raise_error(NoMethodError, "undefined method `[]' for nil:NilClass, maybe it attempted to access: <Hash>[:foo][:baz][:bar] but <Hash>[:foo][:baz] is nil")
    end
  end


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
    before{ BracketErrorSuggestion.disable }

    context Hash do
      it{ tree[:foo1].should be_a(Hash) }
      it{ tree[:foo1][:bar1].should == :baz1 }
      it{ tree[:foo1][:bar2].should be_nil }
      it "raises NoMethodError" do
        expect{ tree[:foo1][:bar2][:baz2] }.to raise_error(NoMethodError, "undefined method `[]' for nil:NilClass")
      end
    end

    context Array do
      it{ tree["foo2"].should be_a(Array) }
      it{ tree["foo2"][0].should == {"bar1" => :baz1} }
      it{ tree["foo2"][99].should be_nil }
      it "raises TypeError" do
        expect{ tree["foo2"]["hoge"] }.to raise_error(TypeError, "no implicit conversion of String into Integer")
      end
    end
  end

  context :enabled do
    before{ BracketErrorSuggestion.enable }
    after{ BracketErrorSuggestion.disable }

    context Hash do
      it{ tree[:foo1].should be_a(Hash) }
      it{ tree[:foo1][:bar1].should == :baz1 }
      it{ tree[:foo1][:bar2].should be_nil }
      it "raises NoMethodError" do
        msg = "undefined method `[]' for nil:NilClass, maybe it attempted to access: <Hash>[:foo1][:bar2][:baz2] but <Hash>[:foo1][:bar2] is nil"
        expect{ tree[:foo1][:bar2][:baz2] }.to raise_error(NoMethodError, msg)
      end

      it "show all suggestions" do
        tree[:foo1][:bar3]
        msg = "undefined method `[]' for nil:NilClass, maybe it attempted to access: " + [
          "<Hash>[:foo1][:bar2][:baz2] but <Hash>[:foo1][:bar2] is nil",
          "<Hash>[:foo1][:bar3][:baz2] but <Hash>[:foo1][:bar3] is nil"
        ].join(", ")
        expect{ tree[:foo1][:bar2][:baz2] }.to raise_error(NoMethodError, msg)
      end
    end

    context Array do
      it{ tree["foo2"].should be_a(Array) }
      it{ tree["foo2"][0].should == {"bar1" => :baz1} }
      it{ tree["foo2"][99].should be_nil }
      it "raises TypeError" do
        msg = "no implicit conversion of String into Integer, it attempted to access <Hash>[\"foo2\"][\"hoge\"] but <Hash>[\"foo2\"] is an Array"
        expect{ tree["foo2"]["hoge"] }.to raise_error(TypeError, msg)
      end
    end
  end

end
