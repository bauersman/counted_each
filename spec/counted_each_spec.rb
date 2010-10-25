require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CountedEach" do
  it 'should provide a counted_each method to instances of Array' do
    CountedEach::Config.output = STDERR

    [].should respond_to :counted_each
    arr1 = (0...40000).to_a
    arr2 = []

    arr1.counted_each do |i|
      arr2 << i
      sleep(0.01)
    end

    arr2.should == arr1
  end
end
