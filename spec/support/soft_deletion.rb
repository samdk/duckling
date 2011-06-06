shared_context 'soft deletable' do

  context "when deleted" do
      before :all do
        subject.class.delete_all
        
        subject.save(validate: false)        
        subject.delete      
      end
      
      it "should be restorable" do
        subject.deleted?.should be_true
      end
      
      it "shouldn't show up by default" do
        subject.class.exists?(subject.id).should be_false
        subject.class.with_deleted.exists?(subject.id).should be_true
        subject.class.deleted.exists?(subject.id).should be_true
      end
      
      it "should record deletion timestamp" do
        subject.deleted_at.should >= (DateTime.now - 1.seconds)
        subject.deleted_at.should <= DateTime.now
      end
    end
  
    context "when not deleted" do
      before :all do
        subject.save(validate: false)
      end
      
      it "should have an ID" do
        subject.id.should_not be_nil
      end
      
      it "should not have a deleted at" do
        subject.deleted_at.should be_nil
      end
      
      it "should show up by default" do
        subject.class.exists?(subject.id)
        subject.class.with_deleted.exists?(subject.id).should be_true
        subject.class.deleted.exists?(subject.id).should be_false
      end
    end
    
    context "when restored" do
      
      before :all do
        subject.save(validate: false)
        subject.delete
        subject.restore
      end
      
      it "should not have a deleted at" do
        subject.deleted_at.should be_nil
      end
      
      it "should show up again" do
        subject.class.exists?(subject.id)
        subject.class.with_deleted.exists?(subject.id).should be_true
        subject.class.deleted.exists?(subject.id).should be_false
      end
    end
end
