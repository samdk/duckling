shared_examples_for 'soft deletable' do
        
  it "should be restorable" do
    subject.deleted?.should be_false
    subject.destroy
    subject.deleted?.should be_true
    subject.restore
    subject.deleted?.should be_false
  end
  
  it "shouldn't show up by default" do
    subject.class.exist?(subject.id).should be_true
    subject.class.deleted.exist?(subject.id).should be_false
    subject.destroy
    subject.class.exist?(subject.id).should be_false
    subject.class.including_deleted.exist?(subject.id).should be_true
    subject.class.deleted.exist?(subject.id).should be_true
  end
  
  it "should record deletion timestamp" do
    subject.destroy
    subject.deleted_at.should >= (DateTime.now - 1.seconds)
    subject.deleted_at.should <= DateTime.now
    subject.restore
    subject.deleted_at.should == nil
  end
  
end
