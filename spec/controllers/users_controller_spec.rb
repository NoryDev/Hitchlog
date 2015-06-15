require 'spec_helper'

describe UsersController do
  describe "#send_mail" do
    let(:action) { get :send_mail, :id => 1 }
    before { User.stub_chain(:includes, :find).and_return(double('user')) }

    it_blocks_unauthenticated_access

    it "renders get_mail template" do
      sign_in :user, double('user')

      response.should render_template(action: 'get_mail')
    end
  end

  describe "#mail_sent" do
    let(:action) { post :mail_sent, id: 'flov', message_body: 'text' }
    let(:current_user) { double('user1',
                                username: 'flov',
                                to_param: 'flov',
                                email: 'flov@hitchlog.com') }
    let(:mail_to_user) { double('user2',
                                'attributes=' => '',
                                username: 'Malte',
                                to_param: 'malte',
                                email: 'malte@tramprennen.org') }
    let(:user_mailer) { double('UserMailer') }

    it_blocks_unauthenticated_access

    before do
      User.stub_chain(:includes, :find).and_return mail_to_user
      user_mailer.stub(:deliver){ true }
      sign_in :user, current_user
    end

    it 'sends out mail' do
      UserMailer.should_receive(:mail_to_user)
        .with(current_user, mail_to_user, 'text')
        .and_return(user_mailer)

      action
    end

    it "redirects to the hitchhikers page" do
      user_mailer.stub(deliver: true)
      UserMailer.stub(:mail_to_user).and_return(user_mailer)

      action

      response.should redirect_to(user_path(mail_to_user))
    end
  end

  describe '#show' do
    let(:action) { get :show, id: 'flov' }
    let(:user)   { double('user') }
    let(:trip)   { double('trip') }
    let(:search)  { double('meta_where') }

    context 'user cant be found' do
      before do
        get :show, id: 'does not exist'
      end

      it 'redirects if user cannot be found' do
        response.should redirect_to(root_path)
      end

      it 'sets the error flash' do
        flash[:error].should == 'The record was not found'
      end
    end


    it 'renders show view' do
      User.stub_chain(:includes, :find).and_return user
      user.stub_chain(:trips, :scoped, :order, :search).and_return( search )
      search.stub_chain(:result, :paginate).and_return(trip)

      action

      response.should render_template :show
    end
  end

  describe "#destroy" do
    context "if logged in" do
      let(:current_user) { double('user') }
      let(:another_user) { double('another_user', to_param: 'another_user') }

      before do 
        sign_in :user, current_user
      end

      context "signed in user tries to destroy another user" do
        before do
          User.stub(:find).and_return(another_user)
          User.stub_chain(:includes, :find).and_return(current_user)
          delete :destroy, id: another_user.to_param
        end

        it "should not delete another user" do
          flash[:alert].should == 'You are not allowed to do that!'
        end

        it "should redirect to the profile path" do
          response.should redirect_to(user_path(current_user))
        end
      end
    end

    context "if not logged in" do
      it "redirects to log in page" do
        User.stub_chain(:includes, :find).and_return(double('user'))

        delete :destroy, id: 1

        response.should redirect_to(user_session_path)
      end
    end
  end

  describe '#geomap' do
    it 'responds with json' do
      get :geomap, format: :json

      response.header['Content-Type'].should include 'application/json'
    end
  end
end
