shared_examples_for 'soft deletable' do
  context "when deleted" do
    before :each do
      puts subject.inspect
      subject.destroy
    end
    
    it "should be restorable" do
      subject.deleted?.should be_true
    end
    
    it "shouldn't show up by default" do
      subject.class.exist?(subject.id).should be_false
      subject.class.including_deleted.exist?(subject.id).should be_true
      subject.class.deleted.exist?(subject.id).should be_true
    end
    
    it "should record deletion timestamp" do
      subject.deleted_at.should >= (DateTime.now - 1.seconds)
      subject.deleted_at.should <= DateTime.now
    end
  end

  context "when not deleted" do
    before :each do
      subject.save
    end
    
    it "should not have a deleted at" do
      subject.deleted_at.should be_nil
    end
    
    it "should show up by default" do
      subject.class.exist?(subject.id)
      subject.class.including_deleted.exist?(subject.id).should be_true
      subject.class.deleted.exist?(subject.id).should be_false
    end
  end
  
  context "when restored" do
    
    before :each do
      subject.save
      subject.delete
      subject.restore
    end
    
    it "should not have a deleted at" do
      subject.deleted_at.should be_nil
    end
    
    it "should show up again" do
      subject.class.exist?(subject.id)
      subject.class.including_deleted.exist?(subject.id).should be_true
      subject.class.deleted.exist?(subject.id).should be_false
    end
  end
end
