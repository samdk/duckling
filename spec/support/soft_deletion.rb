def logging
  arb = ActiveRecord::Base
  old = arb.logger
  arb.logger = Logger.new $>
  yield
  arb.logger = old
end

shared_examples 'soft deletable' do |model_proc|
  
  let :model, &model_proc
  
  context "when deleted" do
      
      it "should claim to be deleted" do
        model.delete
        model.deleted?.should be_true
      end
      
      it "shouldn't show up by default" do
        model.delete
        model.class.exists?(model.id).should be_false
        model.class.unscoped.exists?(model.id).should be_true
        model.class.only_deleted.exists?(model.id).should be_true
      end
      
      it "should record deletion timestamp" do
        model.delete
        model.deleted_at.should >= (DateTime.now - 1.seconds)
        model.deleted_at.should <= DateTime.now
      end
    end
    
    context "when really deleted" do
      it 'should not be soft deleted' do        
        model.delete!
        model.class.unscoped.exists?(model.id).should be_false
      end
    end
  
    context "when not deleted" do
      
      it "should have an ID" do
        model.id.should_not be_nil
      end
      
      it "should not have a deleted at" do
        model.deleted_at.should be_nil
      end
      
      it "should show up by default" do
        model.class.exists?(model.id)
        model.class.unscoped.exists?(model.id).should be_true
        model.class.only_deleted.exists?(model.id).should be_false
      end
    end
    
    context "when restored" do
      
      before :each do
        model.delete
        @restored = model.class.unscoped.find(model.id)
        @restored.skipping_auth!(&:restore!)
      end
      
      it "should not have a deleted at" do
        @restored.deleted_at.should be_nil
      end
      
      it "should show up again" do
        @restored.class.exists?(model.id)
        @restored.class.unscoped.exists?(model.id).should be_true
        @restored.class.only_deleted.exists?(model.id).should be_false
      end
    end
end
